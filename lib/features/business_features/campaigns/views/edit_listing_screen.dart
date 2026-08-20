import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/edit_listing_controller.dart';
import 'widgets/basic_tab_view.dart';
import 'widgets/details_tab_view.dart';
import 'widgets/edit_listing_header.dart';
import 'widgets/edit_listing_tab_bar.dart';
import 'widgets/rewards_tab_view.dart';

class EditListingScreen extends GetView<EditListingController> {
  const EditListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header (Back, Title, Subtitle, Save Button) ──
              EditListingHeader(
                onBack: () => Get.back(),
                onSave: controller.saveListing,
              ),

              const SizedBox(height: 18),

              // ── Segmented Tab Bar ([Basic] | [Details] | [Rewards]) ──
              Obx(
                () => EditListingTabBar(
                  selectedIndex: controller.selectedTab.value,
                  onTabSelected: controller.switchTab,
                ),
              ),

              const SizedBox(height: 20),

              // ── Dynamic Tab Content ──
              Obx(() {
                switch (controller.selectedTab.value) {
                  case 0:
                    return BasicTabView(
                      isLogoUploaded: controller.isLogoUploaded.value,
                      onUploadLogo: controller.uploadLogo,
                      onRemoveLogo: controller.removeLogo,
                      businessNameController:
                          controller.businessNameController,
                      categories: controller.categories,
                      selectedCategory: controller.selectedCategory.value,
                      onSelectCategory: controller.selectCategory,
                      descriptionController:
                          controller.descriptionController,
                    );
                  case 1:
                    return DetailsTabView(
                      addressController: controller.addressController,
                      phoneController: controller.phoneController,
                      websiteController: controller.websiteController,
                      hoursOptions: controller.hoursOptions,
                      selectedHours: controller.selectedHours.value,
                      onSelectHours: controller.selectHours,
                    );
                  case 2:
                    return RewardsTabView(
                      selectedReward: controller.selectedReward.value,
                      onSelectPresetReward: controller.selectPresetReward,
                      customRewardController:
                          controller.customRewardController,
                      onCustomRewardChanged: controller.onCustomRewardChanged,
                      presetRewards: controller.presetRewards,
                      businessName: controller.businessNameController.text,
                      category: controller.selectedCategory.value,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
