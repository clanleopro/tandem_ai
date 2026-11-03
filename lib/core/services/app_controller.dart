import 'dart:async';

import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../data/models/analysis_report.dart';
import '../../data/models/discussion_message.dart';
import '../../data/models/document_item.dart';
import '../../data/models/project_model.dart';
import 'mock_data_service.dart';

/// The screens the app can be on.
enum AppScreen { landing, login, signup, workspace }

/// The sub-views inside the workspace.
enum WorkspaceView { wizard, report }

/// Centralized Controller that coordinates application state and provides
/// backward compatibility across the codebase.
class AppController extends GetxController {
  // ─── Navigation ──────────────────────────────────────────────────────────
  final Rx<AppScreen> currentScreen = AppScreen.workspace.obs;
  final Rx<WorkspaceView> workspaceView = WorkspaceView.wizard.obs;

  // ─── Auth (mock) ─────────────────────────────────────────────────────────
  final RxBool isLoggedIn = true.obs;
  final RxString currentUserName = 'Divya'.obs;
  final RxString currentUserRole = 'Senior Crane & Rigging Specialist'.obs;
  final RxString currentUserEmail = 'divya.rigging@titanheavy.com'.obs;
  final RxString companyName = 'Titan Rigging & Heavy Lift Corp'.obs;

  // ─── Projects ────────────────────────────────────────────────────────────
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final Rx<ProjectModel?> activeProject = Rx(null);

  /// Set of project IDs for which we have a cached report this session.
  final RxSet<String> projectsWithReport = <String>{}.obs;

  // ─── Document Review State ───────────────────────────────────────────────
  final RxBool isNewDocumentSelected = true.obs;
  final RxInt wizardStep = 1.obs;

  // ─── Document dropdown sources ───────────────────────────────────────────
  final RxList<DocumentItem> standardDocs = <DocumentItem>[].obs;
  final RxList<DocumentItem> liftPlanDocs = <DocumentItem>[].obs;

  // ─── Discussion (mock) ───────────────────────────────────────────────────
  final RxList<DiscussionMessage> discussionMessages =
      <DiscussionMessage>[].obs;

  final RxDouble analysisProgress = 0.0.obs;
  final RxString analysisStatusMessage = 'Initializing AI Analysis...'.obs;

  // ─── Lifecycle ───────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  void _initData() {
    projects.assignAll(MockDataService.getInitialProjects());
    activeProject.value = projects.isNotEmpty ? projects.first : null;
    standardDocs.assignAll(MockDataService.getStandardDocuments());
    liftPlanDocs.assignAll(MockDataService.getLiftPlanDocuments());
    discussionMessages.assignAll(MockDataService.getInitialDiscussion());

    isNewDocumentSelected.value = true;
    wizardStep.value = 1;
    workspaceView.value = WorkspaceView.wizard;
  }

  // ─── Navigation ──────────────────────────────────────────────────────────
  void navigateTo(AppScreen screen) {
    currentScreen.value = screen;
    switch (screen) {
      case AppScreen.landing:
        Get.toNamed(AppRoutes.landing);
        break;
      case AppScreen.login:
        Get.toNamed(AppRoutes.login);
        break;
      case AppScreen.signup:
        Get.toNamed(AppRoutes.signup);
        break;
      case AppScreen.workspace:
        Get.toNamed(AppRoutes.workspace);
        break;
    }
  }

  void setWorkspaceView(WorkspaceView view) => workspaceView.value = view;

  // ─── Auth ────────────────────────────────────────────────────────────────
  void login({String? email, String? company}) {
    isLoggedIn.value = true;
    if (email != null && email.isNotEmpty) currentUserEmail.value = email;
    if (company != null && company.isNotEmpty) companyName.value = company;
    currentScreen.value = AppScreen.workspace;
    Get.offAllNamed(AppRoutes.workspace);
  }

  void signup({required String company, required String email}) {
    isLoggedIn.value = true;
    companyName.value = company;
    currentUserEmail.value = email;
    currentScreen.value = AppScreen.workspace;
    Get.offAllNamed(AppRoutes.workspace);
  }

  void logout() {
    isLoggedIn.value = false;
    currentScreen.value = AppScreen.login;
    Get.offAllNamed(AppRoutes.login);
  }

  // ─── Project actions ─────────────────────────────────────────────────────
  bool selectProject(ProjectModel project) {
    activeProject.value = project;
    isNewDocumentSelected.value = false;
    final hasReport = projectsWithReport.contains(project.id);
    if (hasReport) {
      workspaceView.value = WorkspaceView.report;
    } else {
      workspaceView.value = WorkspaceView.wizard;
      wizardStep.value = 1;
    }
    return hasReport;
  }

  void createNewProject(String name, String category) {
    final newProj = _makeProject(name, category);
    projects.insert(0, newProj);
    activeProject.value = newProj;
    isNewDocumentSelected.value = false;
    workspaceView.value = WorkspaceView.wizard;
    wizardStep.value = 1;
  }

  void createProjectAndAnalyze(String name, String category) {
    final newProj = _makeProject(name, category);
    projects.insert(0, newProj);
    activeProject.value = newProj;
    isNewDocumentSelected.value = false;
    workspaceView.value = WorkspaceView.wizard;
  }

  ProjectModel _makeProject(String name, String category) {
    return ProjectModel(
      id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isNotEmpty ? name : 'Turbine Generator Dual Lift',
      category: category.isNotEmpty
          ? category
          : 'Critical Tandem Pick, SPMT Transport, Outrigger Ground Check',
      updatedAt: DateTime.now(),
      hasReport: false,
    );
  }

  void startNewDocumentReview() {
    isNewDocumentSelected.value = true;
    wizardStep.value = 1;
    workspaceView.value = WorkspaceView.wizard;
  }

  // ─── Wizard step tracking helpers ────────────────────────────────────────
  void onSourceDocSelected() => wizardStep.value = 2;
  void onSourceDocRemoved() => wizardStep.value = 1;
  void onLiftPlanDocSelected() => wizardStep.value = 2;
  void onLiftPlanDocRemoved() => wizardStep.value = 1;

  // ─── Called when report received ─────────────────────────────────────────
  void onReportReceived(AnalysisReport report) {
    projectsWithReport.add(report.projectId);
    final index = projects.indexWhere((p) => p.id == report.projectId);
    if (index != -1) {
      projects[index] = projects[index].copyWith(hasReport: true);
      activeProject.value = projects[index];
    }
    isNewDocumentSelected.value = false;
    workspaceView.value = WorkspaceView.report;
  }

  // ─── Dropdown list mutations ─────────────────────────────────────────────
  void addCustomStandardDoc(DocumentItem doc) => standardDocs.insert(0, doc);
  void addCustomLiftPlanDoc(DocumentItem doc) => liftPlanDocs.insert(0, doc);

  // ─── Discussion (mock) ───────────────────────────────────────────────────
  Timer? _replyTimer;

  void addDiscussionMessage(String text) {
    if (text.trim().isEmpty) return;
    discussionMessages.add(
      DiscussionMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderName: currentUserName.value,
        senderRole: 'Reviewing Engineer',
        text: text.trim(),
        timestamp: DateTime.now(),
        isFromEngineer: false,
      ),
    );

    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!isClosed) {
        discussionMessages.add(
          DiscussionMessage(
            id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
            senderName: 'Divya',
            senderRole: 'Senior Crane & Rigging Specialist',
            text:
                'Received your note regarding "${text.trim()}". I have flagged this item on Sheet 3 of the lift plan package and notified the site lift supervisor.',
            timestamp: DateTime.now(),
            isFromEngineer: true,
          ),
        );
      }
    });
  }

  @override
  void onClose() {
    _replyTimer?.cancel();
    super.onClose();
  }
}
