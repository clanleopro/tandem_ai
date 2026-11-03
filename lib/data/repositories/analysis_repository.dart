import 'dart:typed_data';

import '../../core/services/analysis_api_service.dart';
import '../models/analysis_report.dart';
import '../models/document_item.dart';

/// Repository interface for document analysis data operations.
abstract class IAnalysisRepository {
  Future<AnalysisReport> analyzeDocuments({
    required DocumentItem referenceDoc,
    required Uint8List referenceBytes,
    required DocumentItem planDoc,
    required Uint8List planBytes,
    required String projectId,
    required String projectName,
  });

  void dispose();
}

/// Production implementation of [IAnalysisRepository] using [AnalysisApiService].
class AnalysisRepository implements IAnalysisRepository {
  final AnalysisApiService _apiService;

  AnalysisRepository({AnalysisApiService? apiService})
    : _apiService = apiService ?? AnalysisApiService();

  @override
  Future<AnalysisReport> analyzeDocuments({
    required DocumentItem referenceDoc,
    required Uint8List referenceBytes,
    required DocumentItem planDoc,
    required Uint8List planBytes,
    required String projectId,
    required String projectName,
  }) {
    return _apiService.analyze(
      referenceDoc: referenceDoc,
      referenceBytes: referenceBytes,
      planDoc: planDoc,
      planBytes: planBytes,
      projectId: projectId,
      projectName: projectName,
    );
  }

  @override
  void dispose() {
    _apiService.dispose();
  }
}
