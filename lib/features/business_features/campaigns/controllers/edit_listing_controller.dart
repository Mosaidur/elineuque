import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dashboard/controllers/business_dashboard_controller.dart';
import '../models/campaign_listing_model.dart';

class EditListingController extends GetxController {
  // Tab index: 0 = Basic, 1 = Details, 2 = Rewards
  final selectedTab = 0.obs;

  // ── Basic Tab ──
  final isLogoUploaded = true.obs;
  late final TextEditingController businessNameController;
  final selectedCategory = 'Fitness'.obs;
  late final TextEditingController descriptionController;

  final categories = const [
    'Café',
    'Fitness',
    'Wellness',
    'Food',
    'Tech',
    'Salon',
    'Retail',
    'Beauty',
  ];

  // ── Details Tab ──
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  late final TextEditingController websiteController;
  final selectedHours = 'Open until 10pm'.obs;

  final hoursOptions = const [
    'Open until 6pm',
    'Open until 8pm',
    'Open until 10pm',
    'Open 24 hours',
    'By appointment',
    'Open until 11pm',
  ];

  // ── Rewards Tab ──
  final selectedReward = 40.obs;
  late final TextEditingController customRewardController;

  final presetRewards = const [10, 15, 20, 25, 30, 40, 50, 75, 100];

  @override
  void onInit() {
    super.onInit();
    // Initialize with existing data from dashboard if available
    String initName = 'FitZone Gym';
    String initDesc =
        "San Francisco's premium functional fitness gym. State-of-the-art equipment, expert coaches, and a community that shows";
    String initHours = 'Open until 10pm';
    int initReward = 40;

    if (Get.isRegistered<BusinessDashboardController>()) {
      final dashboard = Get.find<BusinessDashboardController>();
      initName = dashboard.businessName.value;
      initDesc = dashboard.listingDescription.value;
      initHours = dashboard.listingHours.value;
      final digits =
          dashboard.rewardPerReferral.value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isNotEmpty) {
        initReward = int.tryParse(digits) ?? 40;
      }
    }

    businessNameController = TextEditingController(text: initName);
    descriptionController = TextEditingController(text: initDesc);
    addressController = TextEditingController(text: '480 Brannan St, SF');
    phoneController = TextEditingController(text: '+1 415 555 0202');
    websiteController = TextEditingController(text: 'fitzonegym.com');
    selectedHours.value = initHours;
    selectedReward.value = initReward;
    customRewardController = TextEditingController(text: '$initReward');
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectHours(String hours) {
    selectedHours.value = hours;
  }

  void selectPresetReward(int amount) {
    selectedReward.value = amount;
    customRewardController.text = '$amount';
  }

  void onCustomRewardChanged(String val) {
    final parsed = int.tryParse(val.trim());
    if (parsed != null && parsed > 0) {
      selectedReward.value = parsed;
    }
  }

  void uploadLogo() {
    isLogoUploaded.value = true;
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Upload Logo',
        'Logo updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeLogo() {
    isLogoUploaded.value = false;
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Remove Logo',
        'Photo removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void saveListing() {
    final name = businessNameController.text.trim();
    if (name.isEmpty) {
      if (Get.context != null && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          'Validation Error',
          'Business name cannot be empty.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }

    // Update BusinessDashboardController if registered
    if (Get.isRegistered<BusinessDashboardController>()) {
      final dashboard = Get.find<BusinessDashboardController>();
      dashboard.businessName.value = name;
      dashboard.updateListing(
        name: name,
        category: selectedCategory.value,
        hours: selectedHours.value,
        description: descriptionController.text.trim(),
        rewardPerReferral: '\$${selectedReward.value}',
      );
    }

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Saved',
        'Listing updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    if (Get.key.currentState != null) {
      Get.back();
    }
  }

  CampaignListingModel getCurrentListingModel() {
    return CampaignListingModel(
      businessName: businessNameController.text.trim(),
      category: selectedCategory.value,
      description: descriptionController.text.trim(),
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      website: websiteController.text.trim(),
      openingHours: selectedHours.value,
      rewardAmount: selectedReward.value,
    );
  }

  @override
  void onClose() {
    businessNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    customRewardController.dispose();
    super.onClose();
  }
}
