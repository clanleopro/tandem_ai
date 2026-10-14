import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/engineering_footer.dart';
import '../controllers/home_controller.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_history_grid.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppHeader(onStartNewAudit: controller.startNewAudit),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Focused Hero Section with Single Primary CTA
                      HeroSection(onStartAudit: controller.startNewAudit),

                      const SizedBox(height: 24),

                      // 2. Active Audit Alert Notice (if active report exists)
                      // Obx(() {
                      //   final report = controller.activeReport.value;
                      //   if (report == null) return const SizedBox.shrink();
                      //   return Column(
                      //     children: [
                      //       ActiveAuditBanner(
                      //         report: report,
                      //         onInspectReport: controller.inspectActiveReport,
                      //         onOpenAuditor: () => controller.openAiConsole(),
                      //       ),
                      //       const SizedBox(height: 40),
                      //     ],
                      //   );
                      // }),

                      // 3. Automated Compliance Architecture Pipeline
                      // const PipelineOverview(),

                      // 4. Rigging Audit Records Grid
                      Obx(
                        () => ProjectsHistoryGrid(
                          projects: controller.projects.toList(),
                          onSelectProject: controller.selectProject,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Engineering Disclaimer Footer
          const EngineeringFooter(),
        ],
      ),
    );
  }
}
