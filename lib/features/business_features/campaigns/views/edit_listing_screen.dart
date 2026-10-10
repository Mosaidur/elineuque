import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/edit_listing_controller.dart';
import 'widgets/basic_tab_view.dart';
import 'widgets/details_tab_view.dart';
import 'widgets/edit_listing_header.dart';
import 'widgets/edit_listing_tab_bar.dart';
import 'widgets/rewards_tab_view.dart';

class EditListingScreen extends StatefulWidget {
  const EditListingScreen({super.key});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EditListingController>().fetchProfile(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EditListingController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.businessPrimary),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header (Back, Title, Subtitle, Save Button) ──
                    EditListingHeader(
                      onBack: () => Navigator.of(context).pop(),
                      onSave: () => controller.saveListing(context),
                    ),

                    const SizedBox(height: 18),

                    // ── Segmented Tab Bar ([Basic] | [Details] | [Rewards]) ──
                    EditListingTabBar(
                      selectedIndex: controller.selectedTab,
                      onTabSelected: controller.switchTab,
                    ),

                    const SizedBox(height: 20),

                    // ── Dynamic Tab Content ──
                    Builder(
                      builder: (context) {
                        switch (controller.selectedTab) {
                          case 0:
                            return BasicTabView(
                              isLogoUploaded: controller.isLogoUploaded,
                              onUploadLogo: () => controller.uploadLogo(context),
                              onRemoveLogo: () => controller.removeLogo(context),
                              businessNameController: controller.businessNameController,
                              categories: controller.categories,
                              selectedCategory: controller.selectedCategory,
                              onSelectCategory: controller.selectCategory,
                              descriptionController: controller.descriptionController,
                            );
                          case 1:
                            return DetailsTabView(
                              addressController: controller.addressController,
                              phoneController: controller.phoneController,
                              websiteController: controller.websiteController,
                              hoursOptions: controller.hoursOptions,
                              selectedHours: controller.selectedHours,
                              onSelectHours: controller.selectHours,
                            );
                          case 2:
                            return RewardsTabView(
                              selectedReward: controller.selectedReward,
                              onSelectPresetReward: controller.selectPresetReward,
                              customRewardController: controller.customRewardController,
                              onCustomRewardChanged: controller.onCustomRewardChanged,
                              presetRewards: controller.presetRewards,
                              businessName: controller.businessNameController.text,
                              category: controller.selectedCategory,
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
