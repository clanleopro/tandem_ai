import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../analysis/controllers/analysis_controller.dart';
import '../../analysis/pages/analysis_wizard_view.dart';
import '../../reports/pages/report_page.dart';
import '../controllers/workspace_controller.dart';
import '../widgets/sidebar.dart';
import '../widgets/workspace_header.dart';

class WorkspacePage extends StatelessWidget {
  final WorkspaceController? workspaceCtrl;
  final AnalysisController? analysisCtrl;

  const WorkspacePage({super.key, this.workspaceCtrl, this.analysisCtrl});

  WorkspaceController get _workspace =>
      workspaceCtrl ?? Get.find<WorkspaceController>();
  AnalysisController get _analysis =>
      analysisCtrl ?? Get.find<AnalysisController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_workspace.workspaceView.value == WorkspaceView.report) {
        return const ReportPage();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          return Scaffold(
            backgroundColor: AppColors.cardBackground,
            drawer: isMobile
                ? Drawer(
                    backgroundColor: AppColors.sidebarBackground,
                    child: Sidebar(
                      workspaceCtrl: _workspace,
                      analysisCtrl: _analysis,
                      onCloseDrawer: () => Navigator.of(context).pop(),
                    ),
                  )
                : null,
            body: Row(
              children: [
                if (!isMobile)
                  Sidebar(workspaceCtrl: _workspace, analysisCtrl: _analysis),
                Expanded(
                  child: Column(
                    children: [
                      WorkspaceHeader(isMobile: isMobile),
                      Expanded(
                        child: AnalysisWizardView(
                          workspaceCtrl: _workspace,
                          analysisCtrl: _analysis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
