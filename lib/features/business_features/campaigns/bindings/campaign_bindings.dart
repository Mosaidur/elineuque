import 'package:get/get.dart';

import '../controllers/campaigns_controller.dart';
import '../controllers/edit_listing_controller.dart';

class CampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignsController>(
      () => CampaignsController(),
    );
    Get.lazyPut<EditListingController>(
      () => EditListingController(),
    );
  }
}
