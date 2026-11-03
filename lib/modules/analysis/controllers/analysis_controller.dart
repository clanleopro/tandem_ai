import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/analysis_report.dart';
import '../../../data/models/document_item.dart';
import '../../../data/repositories/analysis_repository.dart';
import '../../workspace/controllers/workspace_controller.dart';

/// GetxController that owns all state for document analysis:
/// - File picking (PDF validation & byte storage)
/// - Document selection
/// - Analysis submission & error state
/// - Session report cache by project ID
class AnalysisController extends GetxController {
  final IAnalysisRepository _repository;

  AnalysisController({IAnalysisRepository? repository})
    : _repository = repository ?? AnalysisRepository();

  // ─── Reactive State ──────────────────────────────────────────────────────
  final Rx<DocumentItem?> selectedSourceDoc = Rx(null);
  final Rx<DocumentItem?> selectedLiftPlanDoc = Rx(null);

  final RxBool isPickingDocument = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  /// Progress and status tracking for analysis operations
  final RxDouble analysisProgress = 0.0.obs;
  final RxString analysisStatusMessage = 'Initializing AI Analysis...'.obs;

  /// Reports keyed by project ID — session only, not persisted.
  final Map<String, AnalysisReport> reportsByProject = {};

  /// The report being shown right now (for the active project).
  final Rx<AnalysisReport?> currentReport = Rx(null);

  /// Bytes are stored by [DocumentItem.id].
  final Map<String, Uint8List> _fileBytes = {};

  // ─── Derived Getters ─────────────────────────────────────────────────────
  bool get canAnalyze {
    final ref = selectedSourceDoc.value;
    final plan = selectedLiftPlanDoc.value;
    return !isPickingDocument.value &&
        !isSubmitting.value &&
        ref != null &&
        plan != null &&
        _fileBytes.containsKey(ref.id) &&
        _fileBytes.containsKey(plan.id);
  }

  // ─── Document Selection ──────────────────────────────────────────────────
  void selectSourceDocument(DocumentItem doc) {
    selectedSourceDoc.value = doc;
    errorMessage.value = '';
    if (Get.isRegistered<WorkspaceController>()) {
      Get.find<WorkspaceController>().onSourceDocSelected();
    }
  }

  void selectLiftPlanDocument(DocumentItem doc) {
    selectedLiftPlanDoc.value = doc;
    errorMessage.value = '';
    if (Get.isRegistered<WorkspaceController>()) {
      Get.find<WorkspaceController>().onLiftPlanDocSelected();
    }
  }

  void removeSourceDocument() {
    selectedSourceDoc.value = null;
    if (Get.isRegistered<WorkspaceController>()) {
      Get.find<WorkspaceController>().onSourceDocRemoved();
    }
  }

  void removeLiftPlanDocument() {
    selectedLiftPlanDoc.value = null;
    if (Get.isRegistered<WorkspaceController>()) {
      Get.find<WorkspaceController>().onLiftPlanDocRemoved();
    }
  }

  // ─── File Picking ────────────────────────────────────────────────────────
  Future<String?> pickDocument({required bool isStandard}) async {
    if (isPickingDocument.value || isSubmitting.value) {
      return 'Please wait until the current operation finishes.';
    }

    isPickingDocument.value = true;
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result.isEmpty) {
        return null; // User cancelled — silent per specification
      }

      final file = result.first;
      final xFile = file.xFile;
      final size = await xFile.length();

      if (size > AppConstants.maxFileSizeBytes) {
        return 'Each PDF must be 25 MB or smaller.';
      }

      final bytes = await xFile.readAsBytes();
      if (bytes.isEmpty) return 'The selected PDF is empty.';
      if (bytes.length > AppConstants.maxFileSizeBytes) {
        return 'Each PDF must be 25 MB or smaller.';
      }

      final now = DateTime.now();
      final doc = DocumentItem(
        id: 'doc_picked_${now.millisecondsSinceEpoch}',
        fileName: file.name,
        extension: 'PDF',
        sizeString: _formatFileSize(bytes.length),
        description: isStandard
            ? 'Custom reference standard uploaded by user'
            : 'Custom lift plan document uploaded by user',
        isReferenceStandard: isStandard,
        uploadedAt: now,
      );

      _fileBytes[doc.id] = bytes;

      if (Get.isRegistered<WorkspaceController>()) {
        final workspaceCtrl = Get.find<WorkspaceController>();
        if (isStandard) {
          workspaceCtrl.addCustomStandardDoc(doc);
          selectedSourceDoc.value = doc;
          workspaceCtrl.onSourceDocSelected();
        } else {
          workspaceCtrl.addCustomLiftPlanDoc(doc);
          selectedLiftPlanDoc.value = doc;
          workspaceCtrl.onLiftPlanDocSelected();
        }
      }

      return null;
    } catch (_) {
      return 'Could not select the document. Please try again.';
    } finally {
      isPickingDocument.value = false;
    }
  }

  // ─── Document Analysis ───────────────────────────────────────────────────
  Future<bool> analyze({
    required String projectId,
    required String projectName,
  }) async {
    if (!canAnalyze) return false;

    final ref = selectedSourceDoc.value!;
    final plan = selectedLiftPlanDoc.value!;
    final refBytes = _fileBytes[ref.id]!;
    final planBytes = _fileBytes[plan.id]!;

    isSubmitting.value = true;
    errorMessage.value = '';
    analysisProgress.value = 0.15;
    analysisStatusMessage.value = 'Preparing PDFs and transmitting payload...';

    try {
      final report = await _repository.analyzeDocuments(
        referenceDoc: ref,
        referenceBytes: refBytes,
        planDoc: plan,
        planBytes: planBytes,
        projectId: projectId,
        projectName: projectName,
      );

      analysisProgress.value = 1.0;
      analysisStatusMessage.value = 'Analysis complete.';

      reportsByProject[projectId] = report;
      currentReport.value = report;

      if (Get.isRegistered<WorkspaceController>()) {
        Get.find<WorkspaceController>().onReportReceived(report);
      }
      return true;
    } catch (error) {
      final msg = error
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceFirst('FormatException: ', '');
      errorMessage.value = msg;
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ─── Project Switch ──────────────────────────────────────────────────────
  void switchToProject(String projectId) {
    currentReport.value = reportsByProject[projectId];
    selectedSourceDoc.value = null;
    selectedLiftPlanDoc.value = null;
    errorMessage.value = '';
  }

  void clearForNewReview() {
    selectedSourceDoc.value = null;
    selectedLiftPlanDoc.value = null;
    currentReport.value = null;
    errorMessage.value = '';
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────
  String _formatFileSize(int bytes) => bytes >= 1024 * 1024
      ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'
      : '${(bytes / 1024).toStringAsFixed(1)} KB';

  @override
  void onClose() {
    _repository.dispose();
    super.onClose();
  }
}
