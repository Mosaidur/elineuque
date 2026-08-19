import 'package:get/get.dart';

import '../controllers/business_dashboard_controller.dart';

class BusinessDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessDashboardController>(
      () => BusinessDashboardController(),
    );
  }
}
