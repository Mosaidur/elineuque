import 'package:get/get.dart';

import '../controllers/role_select_controller.dart';


class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectionController>(
          () => RoleSelectionController(),
    );
  }
}