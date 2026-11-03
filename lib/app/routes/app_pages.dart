import 'package:get/get.dart';

import '../../modules/analysis/bindings/analysis_binding.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/pages/company_auth_page.dart';
import '../../modules/auth/pages/landing_page.dart';
import '../../modules/auth/pages/login_page.dart';
import '../../modules/auth/pages/signup_page.dart';
import '../../modules/reports/bindings/report_binding.dart';
import '../../modules/reports/pages/report_page.dart';
import '../../modules/workspace/bindings/workspace_binding.dart';
import '../../modules/workspace/pages/workspace_page.dart';
import 'app_routes.dart';

/// Centralized route and page declarations for GetX routing.
class AppPages {
  AppPages._();

  static const String initial = AppRoutes.workspace;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.companyAuth,
      page: () => const CompanyAuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.workspace,
      page: () => const WorkspacePage(),
      bindings: [
        AuthBinding(),
        WorkspaceBinding(),
        AnalysisBinding(),
        ReportBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportPage(),
      binding: ReportBinding(),
    ),
  ];
}

