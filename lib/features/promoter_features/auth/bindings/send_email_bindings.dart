import 'package:get/get.dart';

import '../controllers/send_email_controller.dart';

class SendEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendEmailController>(
      () => SendEmailController(),
    );
  }
}
