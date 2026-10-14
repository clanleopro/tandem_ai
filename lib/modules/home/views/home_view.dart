import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tandem/shared/controllers/auth_controller.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_header.dart';

import '../controllers/home_controller.dart';
import '../widgets/hero_section.dart';
import '../widgets/projects_history_grid.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppHeader(
        onStartNewAudit: controller.startNewAudit,
      ),
      body: Obx(() {
        final isLoggedIn = auth.isLoggedIn.value;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1240),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeroSection(
                          onStartAudit: () {
                            if (auth.isLoggedIn.value) {
                              controller.startNewAudit();
                            } else {
                              auth.showLoginModal(context);
                            }
                          },
                        ),

                        if (isLoggedIn) ...[
                          const SizedBox(height: 24),
                          Obx(
                            () => ProjectsHistoryGrid(
                              projects: controller.projects.toList(),
                              onSelectProject: controller.selectProject,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}