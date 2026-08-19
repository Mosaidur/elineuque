import 'package:get/get.dart';

import '../controllers/business_referral_controller.dart';

class BusinessReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessReferralController>(
      () => BusinessReferralController(),
    );
  }
}
