import 'package:get/get.dart';

import '../../../core/services/mock_data_service.dart';
import '../../../data/models/analysis_report.dart';
import '../../../data/models/document_item.dart';
import '../../../data/models/project_model.dart';

/// The sub-views inside the workspace.
enum WorkspaceView { wizard, report }

/// GetxController responsible for workspace state:
/// - projects list and active project selection
/// - cached reports tracking per project
/// - wizard step tracking
/// - document dropdown items
class WorkspaceController extends GetxController {
  final Rx<WorkspaceView> workspaceView = WorkspaceView.wizard.obs;

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

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() {
    projects.assignAll(MockDataService.getInitialProjects());
    activeProject.value = projects.isNotEmpty ? projects.first : null;
    standardDocs.assignAll(MockDataService.getStandardDocuments());
    liftPlanDocs.assignAll(MockDataService.getLiftPlanDocuments());

    isNewDocumentSelected.value = true;
    wizardStep.value = 1;
    workspaceView.value = WorkspaceView.wizard;
  }

  void setWorkspaceView(WorkspaceView view) => workspaceView.value = view;

  // ─── Project Actions ─────────────────────────────────────────────────────

  /// Select an existing project from the sidebar.
  /// Returns true if the project has a cached report.
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

  /// Creates a new project, sets it as active, and returns it.
  /// Returns null only if creation fails (which currently cannot happen locally,
  /// but provides the right contract for callers that need to await the result).
  ProjectModel createProjectAndReturn(String name, String category) {
    final newProj = _makeProject(name, category);
    projects.insert(0, newProj);
    activeProject.value = newProj;
    isNewDocumentSelected.value = false;
    workspaceView.value = WorkspaceView.wizard;
    return newProj;
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

  // ─── Wizard step tracking ────────────────────────────────────────────────
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
}
