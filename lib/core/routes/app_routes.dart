import 'package:get/get.dart';
import '../../modules/audit/bindings/audit_binding.dart';
import '../../modules/audit/views/audit_report_view.dart';
import '../../modules/audit/views/audit_wizard_view.dart';
import '../../modules/console/bindings/console_binding.dart';
import '../../modules/console/views/ai_auditor_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';

class AppRoutes {
  static const String home = '/';
  static const String auditWizard = '/audit/new';
  static const String auditReport = '/audit/report';
  static const String auditorConsole = '/console';

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: auditWizard,
      page: () => const AuditWizardView(),
      binding: AuditBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: auditReport,
      page: () => const AuditReportView(),
      binding: AuditBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: auditorConsole,
      page: () => const AiAuditorView(),
      binding: ConsoleBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
