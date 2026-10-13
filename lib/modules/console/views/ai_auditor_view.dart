import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/rigging_models.dart';
import '../../../shared/widgets/app_header.dart';
import '../../../shared/widgets/engineering_footer.dart';
import '../controllers/console_controller.dart';

class AiAuditorView extends GetView<ConsoleController> {
  const AiAuditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppHeader(
        onStartNewAudit: () => Get.toNamed(AppRoutes.auditWizard),
      ),
      body: Column(
        children: [
          // Breadcrumb Navigation
          _buildTopHeader(),

          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Engineering Telemetry & Quick Prompts Sidebar
                            SizedBox(
                              width: 310,
                              child: _buildSidebar(),
                            ),
                            const SizedBox(width: 20),
                            // Right Interactive Chat Studio
                            Expanded(
                              child: _buildChatStudio(),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildMobileQuickPrompts(),
                            const SizedBox(height: 12),
                            Expanded(child: _buildChatStudio()),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const EngineeringFooter(),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(bottom: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => Get.offNamed(AppRoutes.auditReport),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to Audit Report'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.cardBorder),
                  foregroundColor: AppTheme.textSecondary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Industrial AI Rigging Auditor Studio',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  Text(
                    'Live engineering dialogue, formula rework, and regulatory clause verification',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final report = controller.activeReport.value;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Lift Plan Parameters
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 16, color: AppTheme.accentRed),
                    const SizedBox(width: 8),
                    const Text(
                      'ACTIVE LIFT TELEMETRY',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _SidebarParam(label: 'PROJECT', value: report?.projectName ?? 'Turbine Generator Module 4'),
                const SizedBox(height: 8),
                _SidebarParam(label: 'STANDARD', value: report?.standard.code ?? 'ASME B30.9-2021'),
                const SizedBox(height: 8),
                const _SidebarParam(label: 'TOTAL LOAD', value: '142.5 MT'),
                const SizedBox(height: 8),
                const _SidebarParam(label: 'SLING ANGLE', value: '41.5° (Failed: < 45°)', isAlert: true),
                const SizedBox(height: 8),
                const _SidebarParam(label: 'HARDWARE D/d', value: '0.95 (Deficient: < 1.0)', isAlert: true),
                const SizedBox(height: 8),
                const _SidebarParam(label: 'SAFETY FACTOR', value: '4.1:1 (Deficient: < 5.0)', isAlert: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Engineering Quick Prompts
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, size: 16, color: AppTheme.amberWarning),
                    const SizedBox(width: 8),
                    const Text(
                      'ENGINEERING DIRECTIVES',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...controller.quickPrompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => controller.handleSend(prompt),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          border: Border.all(color: AppTheme.cardBorder),
                        ),
                        child: Text(
                          prompt,
                          style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileQuickPrompts() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.quickPrompts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final p = controller.quickPrompts[index];
          return ActionChip(
            label: Text(p, style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary)),
            backgroundColor: AppTheme.cardDark,
            side: const BorderSide(color: AppTheme.cardBorder),
            onPressed: () => controller.handleSend(p),
          );
        },
      ),
    );
  }

  Widget _buildChatStudio() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          // Chat Stream
          Expanded(
            child: Obx(() {
              final msgs = controller.chatHistory;
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final msg = msgs[index];
                  return _buildChatMessageItem(msg);
                },
              );
            }),
          ),

          // Generating indicator
          Obx(() {
            if (!controller.isGenerating.value) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentRed),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Tandem AI Rigging Auditor calculating safety factors...',
                    style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            );
          }),

          // Input Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.radiusMd),
                bottomRight: Radius.circular(AppTheme.radiusMd),
              ),
              border: Border(top: BorderSide(color: AppTheme.cardBorder)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.inputController,
                    onSubmitted: controller.handleSend,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI Auditor regarding formulas, Crosby shackle sizes, or ASME clauses...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => controller.handleSend(controller.inputController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                  ),
                  child: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessageItem(ChatMessage msg) {
    final isUser = msg.sender == 'user';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
              ),
              child: const Icon(Icons.psychology, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.cardDark : AppTheme.bgDarkAlt,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isUser ? AppTheme.accentRed.withValues(alpha: 0.4) : AppTheme.cardBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUser ? 'Rigging Engineer' : 'TANDEM AI Auditor',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isUser ? AppTheme.accentRed : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                        style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    msg.text,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.cardDark,
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: const Icon(Icons.person, size: 18, color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarParam extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;

  const _SidebarParam({
    required this.label,
    required this.value,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTheme.monoStyle(fontSize: 9.5, color: AppTheme.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTheme.monoStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isAlert ? AppTheme.accentRed : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
