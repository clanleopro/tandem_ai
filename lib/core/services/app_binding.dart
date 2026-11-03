import 'package:get/get.dart';

import '../../app/bindings/initial_binding.dart';

/// Legacy AppBinding that delegates to [InitialBinding].
class AppBinding extends Bindings {
  @override
  void dependencies() {
    InitialBinding().dependencies();
  }
}
