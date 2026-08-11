import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    debugPrint('SplashController initialized');

    _timer = Timer(
      const Duration(seconds: 3),
      () {
        debugPrint('Timer finished');
        debugPrint('Navigating to: ${AppRoutes.roleSelection}');

        Get.offNamed(AppRoutes.roleSelection);
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}