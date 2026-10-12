import 'package:flutter/material.dart';
import '../models/rigging_models.dart';
import '../theme/app_theme.dart';

class ProjectsHistoryView extends StatelessWidget {
  final List<AuditProject> projects;
  final Function(AuditProject) onSelectProject;
  final VoidCallback onStartNewProject;

  const ProjectsHistoryView({
    super.key,
    required this.projects,
    required this.onSelectProject,
    required this.onStartNewProject,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rigging Audit Projects & Records',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Historical lift plans, engineering reviews, and standards verification logs',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: onStartNewProject,
              icon: const Icon(Icons.add, size: 16, color: Colors.black),
              label: const Text(
                'New Project Audit',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cyanAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Projects Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 800;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isCompact ? 1 : 3,
                mainAxisExtent: 260,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectCard(context, project);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, AuditProject project) {
    Color statusColor;
    switch (project.status) {
      case 'Approved':
        statusColor = AppTheme.greenCompliant;
        break;
      case 'Rework Required':
        statusColor = AppTheme.redViolation;
        break;
      default:
        statusColor = AppTheme.amberWarning;
    }

    return InkWell(
      onTap: () => onSelectProject(project),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Standard row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    project.status.toUpperCase(),
                    style: AppTheme.monoStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    project.standard.code,
                    style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.cyanAccent),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Title
            Text(
              project.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            // Location & Client
            Text(
              '${project.siteLocation} • ${project.client}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),

            const Spacer(),

            // File & Tonnage
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, size: 16, color: AppTheme.amberWarning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      project.projectFile.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.monoStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${project.projectFile.totalLoadWeightTons} MT',
                    style: AppTheme.monoStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.cyanAccent),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action row
            Row(
              children: [
                if (project.report != null) ...[
                  Text(
                    '${project.report!.overallComplianceScore}% Score',
                    style: AppTheme.monoStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  'Open Studio →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.cyanAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
