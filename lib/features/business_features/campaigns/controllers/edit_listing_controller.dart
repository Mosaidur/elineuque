import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../dashboard/controllers/business_dashboard_controller.dart';
import '../models/campaign_listing_model.dart';

class EditListingController extends ChangeNotifier {
  // Tab index: 0 = Basic, 1 = Details, 2 = Rewards
  int _selectedTab = 0;
  bool _isLoading = false;

  int get selectedTab => _selectedTab;
  bool get isLoading => _isLoading;

  // ── Basic Tab ──
  bool isLogoUploaded = true;
  final businessNameController = TextEditingController(text: 'FitZone Gym');
  String selectedCategory = 'Fitness';
  final descriptionController = TextEditingController(
    text: "San Francisco's premium functional fitness gym. State-of-the-art equipment, expert coaches, and a community that shows",
  );

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
  final addressController = TextEditingController(text: '480 Brannan St, SF');
  final phoneController = TextEditingController(text: '+1 415 555 0202');
  final websiteController = TextEditingController(text: 'fitzonegym.com');
  String selectedHours = 'Open until 10pm';

  final hoursOptions = const [
    'Open until 6pm',
    'Open until 8pm',
    'Open until 10pm',
    'Open 24 hours',
    'By appointment',
    'Open until 11pm',
  ];

  // ── Rewards Tab ──
  int selectedReward = 40;
  final customRewardController = TextEditingController(text: '40');

  final presetRewards = const [10, 15, 20, 25, 30, 40, 50, 75, 100];

  Future<void> fetchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final response = await ApiClient.get(ApiConstants.userProfile, withAuth: true);

    _isLoading = false;

    if (response.success && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final bName = data['businessName']?.toString() ?? data['name']?.toString();
      if (bName != null && bName.isNotEmpty) {
        businessNameController.text = bName;
      }

      final cat = data['category']?.toString();
      if (cat != null && cat.isNotEmpty && categories.contains(cat)) {
        selectedCategory = cat;
      }

      final bio = data['bio']?.toString();
      if (bio != null && bio.isNotEmpty) {
        descriptionController.text = bio;
      }

      final addr = data['address']?.toString();
      if (addr != null && addr.isNotEmpty) {
        addressController.text = addr;
      }

      final ph = data['phone']?.toString();
      if (ph != null && ph.isNotEmpty) {
        phoneController.text = ph;
      }

      final web = data['website']?.toString();
      if (web != null && web.isNotEmpty) {
        websiteController.text = web;
      }

      final hrs = data['hours']?.toString();
      if (hrs != null && hrs.isNotEmpty && hoursOptions.contains(hrs)) {
        selectedHours = hrs;
      }
    }

    notifyListeners();
  }

  void switchTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void selectHours(String hours) {
    selectedHours = hours;
    notifyListeners();
  }

  void selectPresetReward(int amount) {
    selectedReward = amount;
    customRewardController.text = '$amount';
    notifyListeners();
  }

  void onCustomRewardChanged(String val) {
    final parsed = int.tryParse(val.trim());
    if (parsed != null && parsed > 0) {
      selectedReward = parsed;
      notifyListeners();
    }
  }

  void uploadLogo(BuildContext context) {
    isLogoUploaded = true;
    notifyListeners();
    _showSnackbar(context, 'Logo updated successfully.');
  }

  void removeLogo(BuildContext context) {
    isLogoUploaded = false;
    notifyListeners();
    _showSnackbar(context, 'Photo removed.');
  }

  Future<void> saveListing(BuildContext context) async {
    final name = businessNameController.text.trim();
    if (name.isEmpty) {
      _showSnackbar(context, 'Business name cannot be empty.', isError: true);
      return;
    }

    _isLoading = true;
    notifyListeners();

    final payload = {
      'businessName': name,
      'category': selectedCategory,
      'bio': descriptionController.text.trim(),
      'address': addressController.text.trim(),
      'phone': phoneController.text.trim(),
      'website': websiteController.text.trim(),
      'hours': selectedHours,
    };

    final response = await ApiClient.patch(
      ApiConstants.userProfile,
      body: payload,
      withAuth: true,
    );

    _isLoading = false;
    notifyListeners();

    if (response.success) {
      // Sync with BusinessDashboardController
      if (context.mounted) {
        try {
          final dashboard = context.read<BusinessDashboardController>();
          dashboard.updateListing(
            name: name,
            category: selectedCategory,
            hours: selectedHours,
            description: descriptionController.text.trim(),
            rewardPerReferral: '\$$selectedReward',
          );
        } catch (_) {}

        _showSnackbar(context, 'Listing updated successfully!');
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Get.back();
        }
      }
    } else {
      if (context.mounted) {
        _showSnackbar(
          context,
          response.message.isNotEmpty ? response.message : 'Failed to update listing.',
          isError: true,
        );
      }
    }
  }

  CampaignListingModel getCurrentListingModel() {
    return CampaignListingModel(
      businessName: businessNameController.text.trim(),
      category: selectedCategory,
      description: descriptionController.text.trim(),
      address: addressController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      website: websiteController.text.trim(),
      openingHours: selectedHours,
      rewardAmount: selectedReward,
    );
  }

  void _showSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF0F9D58),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    businessNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    customRewardController.dispose();
    super.dispose();
  }
}
