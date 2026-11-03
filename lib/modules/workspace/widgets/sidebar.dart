import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/tandem_logo.dart';
import '../../../data/models/project_model.dart';
import '../../analysis/controllers/analysis_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/workspace_controller.dart';

class Sidebar extends StatelessWidget {
  final WorkspaceController? workspaceCtrl;
  final AnalysisController? analysisCtrl;
  final VoidCallback? onCloseDrawer;

  const Sidebar({
    super.key,
    this.workspaceCtrl,
    this.analysisCtrl,
    this.onCloseDrawer,
  });

  WorkspaceController get _workspace =>
      workspaceCtrl ?? Get.find<WorkspaceController>();
  AnalysisController get _analysis =>
      analysisCtrl ?? Get.find<AnalysisController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.sidebarBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 28,
              bottom: 24,
              right: 20,
            ),
            child: TandemLogo(
              isDarkBadge: false,
              onTap: () {
                _workspace.setWorkspaceView(WorkspaceView.wizard);
                onCloseDrawer?.call();
              },
            ),
          ),
          // "New Document" button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final isNewDoc = _workspace.isNewDocumentSelected.value;
              return InkWell(
                onTap: () {
                  onCloseDrawer?.call();
                  _workspace.startNewDocumentReview();
                  _analysis.clearForNewReview();
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isNewDoc
                        ? const Color(0xFF35373F)
                        : AppColors.sidebarCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isNewDoc
                          ? const Color(0xFF4A4E58)
                          : AppColors.sidebarBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: AppColors.sidebarTextActive,
                        size: 17,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppStrings.newDocument,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.sidebarTextActive,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.sidebarTextMuted,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.projects,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sidebarTextActive,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.sidebarTextMuted,
                  size: 19,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              final projects = _workspace.projects;
              final activeId = _workspace.activeProject.value?.id;
              final isNewDoc = _workspace.isNewDocumentSelected.value;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final isSelected = !isNewDoc && activeId == project.id;
                  return _SidebarProjectItem(
                    project: project,
                    isSelected: isSelected,
                    onTap: () {
                      _workspace.selectProject(project);
                      _analysis.switchToProject(project.id);
                      onCloseDrawer?.call();
                    },
                  );
                },
              );
            }),
          ),
          Container(height: 1, color: AppColors.sidebarBorder),
          InkWell(
            onTap: () {
              onCloseDrawer?.call();
              if (Get.isRegistered<AuthController>()) {
                Get.find<AuthController>().logout();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: AppColors.sidebarTextMuted,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.logOut,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.sidebarTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarProjectItem extends StatefulWidget {
  final ProjectModel project;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarProjectItem({
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarProjectItem> createState() => _SidebarProjectItemState();
}

class _SidebarProjectItemState extends State<_SidebarProjectItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.sidebarHover
                  : (_isHovered ? AppColors.sidebarCard : Colors.transparent),
              borderRadius: BorderRadius.circular(6),
              border: active
                  ? Border.all(color: AppColors.sidebarBorder, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 17,
                  color: active
                      ? AppColors.sidebarTextActive
                      : AppColors.sidebarTextMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      color: active
                          ? AppColors.sidebarTextActive
                          : AppColors.sidebarTextMuted,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: active
                      ? AppColors.sidebarTextActive
                      : (_isHovered
                            ? AppColors.sidebarTextActive
                            : const Color(0xFF555761)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
