import 'package:get/get.dart';

import '../controllers/my_referrals_controller.dart';

class MyReferralsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyReferralsController>(
      () => MyReferralsController(),
    );
  }
}
