import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'shared/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
  runApp(const TandemAiApp());
}

class TandemAiApp extends StatelessWidget {
  const TandemAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TANDEM AI • Rigging Standards Compliance Verifier',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.pages,
    );
  }
}
