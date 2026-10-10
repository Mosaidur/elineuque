import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/business_discover_model.dart';
import '../models/campaign_model.dart';

class DiscoverController extends GetxController {
  final selectedNavIndex = 1.obs; // Discover tab is index 1

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (!Get.testMode) {
      fetchDiscoverBusinesses();
    }
  }

  Future<void> fetchDiscoverBusinesses() async {
    isLoading.value = true;
    try {
      final res = await ApiClient.get(ApiConstants.campaigns, withAuth: true);
      if (res.success && res.data is List) {
        final list = res.data as List;
        final mapped = list.map((c) {
          final id = c['_id']?.toString() ?? c['id']?.toString() ?? '';
          final title = c['title']?.toString() ?? 'Partner Campaign';
          final reward = c['reward']?.toString() ?? '\$20';
          final offer = c['offer']?.toString() ?? 'Exclusive Offer';
          final minSpend = (c['minimumSpend'] as num?)?.toInt() ?? 0;
          final sharedCount = (c['sharedCount'] as num?)?.toInt() ?? 0;

          return BusinessDiscoverModel(
            id: id,
            name: title,
            category: 'All',
            distanceMi: 0.5,
            rating: 4.9,
            rewardPerReferral: reward,
            activePromoters: sharedCount > 0 ? sharedCount : 1,
            isVerified: true,
            icon: Icons.storefront_rounded,
            iconColor: const Color(0xFFC8FF5A),
            location: 'Verified Partner Store',
            hours: 'Active Campaign',
            website: 'eliv.app',
            referralSlug: id,
            campaigns: [
              CampaignModel(
                id: id,
                title: title,
                rewardAmount: reward,
                rewardSuffix: 'per conversion',
                description: '$offer. Minimum spend: \$$minSpend',
                endsDate: c['endDate'] != null ? 'Ends ${c['endDate'].toString().substring(0, 10)}' : 'Ongoing',
                promotersCount: '$sharedCount promoters',
                isActive: true,
              ),
            ],
          );
        }).toList();

        if (mapped.isNotEmpty) {
          businesses.assignAll(mapped);
        }
      }
    } catch (e) {
      debugPrint('Error fetching discover businesses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final categories = <String>[
    'All',
    'Café',
    'Fitness',
    'Wellness',
    'Food',
    'Salon',
  ];

  final businesses = <BusinessDiscoverModel>[
    const BusinessDiscoverModel(
      id: '1',
      name: 'Kava Brew',
      category: 'Café',
      distanceMi: 0.3,
      rating: 4.8,
      rewardPerReferral: '\$25',
      activePromoters: 47,
      isVerified: true,
      icon: Icons.coffee_outlined,
      iconColor: Color(0xFFFFA726),
      location: '120 2nd St, San Francisco, CA',
      hours: 'Open until 8pm',
      website: 'kavabrew.com',
      referralSlug: 'kava-brew',
      campaigns: [
        CampaignModel(
          id: 'c1',
          title: 'Oat Latte Referral Special',
          rewardAmount: '\$25',
          rewardSuffix: 'per purchase',
          description:
              'Refer someone who buys any coffee or beverage item. You earn \$25 instantly.',
          endsDate: 'Ends Aug 28',
          promotersCount: '47 promoters',
          isActive: true,
        ),
        CampaignModel(
          id: 'c2',
          title: 'Bakery Combo Reward',
          rewardAmount: '\$15',
          rewardSuffix: 'per conversion',
          description:
              'Refer friends to try any pastry combo. You earn \$15 on every pastry order.',
          endsDate: 'Ends Sep 10',
          promotersCount: '23 promoters',
          isActive: true,
        ),
      ],
    ),
    const BusinessDiscoverModel(
      id: '2',
      name: 'FitZone Gym',
      category: 'Fitness',
      distanceMi: 0.7,
      rating: 4.9,
      rewardPerReferral: '\$40',
      activePromoters: 128,
      isVerified: true,
      icon: Icons.fitness_center_outlined,
      iconColor: Color(0xFF42A5F5),
      location: '480 Brannan St, SF',
      hours: 'Open until 10pm',
      website: 'fitzonegym.com',
      referralSlug: 'fitzone-gym',
      campaigns: [
        CampaignModel(
          id: 'c3',
          title: 'Summer Membership Drive',
          rewardAmount: '\$40',
          rewardSuffix: 'per conversion',
          description:
              'Refer someone who buys a membership. You earn \$40. They get their first month 50% off.',
          endsDate: 'Ends Aug 31',
          promotersCount: '128 promoters',
          isActive: true,
        ),
        CampaignModel(
          id: 'c4',
          title: 'Double Reward Week',
          rewardAmount: '\$80',
          rewardSuffix: 'per annual signup',
          description:
              'Earn double commission (\$80) when your referral signs up for an annual gym membership.',
          endsDate: 'Ends Aug 25',
          promotersCount: '89 promoters',
          isActive: true,
        ),
      ],
    ),
    const BusinessDiscoverModel(
      id: '3',
      name: 'Luna Spa',
      category: 'Wellness',
      distanceMi: 1.2,
      rating: 4.7,
      rewardPerReferral: '\$30',
      activePromoters: 83,
      isVerified: true,
      icon: Icons.spa_outlined,
      iconColor: Color(0xFFAB47BC),
      location: '750 Market St, SF',
      hours: 'Open until 9pm',
      website: 'lunaspa.com',
      referralSlug: 'luna-spa',
      campaigns: [
        CampaignModel(
          id: 'c5',
          title: 'Summer Glow Package',
          rewardAmount: '\$30',
          rewardSuffix: 'per session',
          description:
              'Refer friends for massage, facial, or therapy packages. You earn \$30 on every session.',
          endsDate: 'Ends Sep 05',
          promotersCount: '83 promoters',
          isActive: true,
        ),
      ],
    ),
    const BusinessDiscoverModel(
      id: '4',
      name: 'TacoFusion',
      category: 'Food',
      distanceMi: 0.5,
      rating: 4.6,
      rewardPerReferral: '\$20',
      activePromoters: 215,
      isVerified: true,
      icon: Icons.restaurant_outlined,
      iconColor: Color(0xFFFF7043),
      location: '320 Valencia St, SF',
      hours: 'Open until 11pm',
      website: 'tacofusion.com',
      referralSlug: 'tacofusion',
      campaigns: [
        CampaignModel(
          id: 'c6',
          title: 'Taco Tuesday & Lunch Promo',
          rewardAmount: '\$20',
          rewardSuffix: 'per order',
          description:
              'Share TacoFusion with your network. Earn \$20 when your friend spends \$25 or more.',
          endsDate: 'Ends Sep 15',
          promotersCount: '215 promoters',
          isActive: true,
        ),
      ],
    ),
    const BusinessDiscoverModel(
      id: '5',
      name: 'CloudCuts',
      category: 'Salon',
      distanceMi: 0.9,
      rating: 4.5,
      rewardPerReferral: '\$15',
      activePromoters: 61,
      isVerified: true,
      icon: Icons.content_cut_outlined,
      iconColor: Color(0xFF26A69A),
      location: '510 Mission St, SF',
      hours: 'Open until 7pm',
      website: 'cloudcuts.com',
      referralSlug: 'cloudcuts',
      campaigns: [
        CampaignModel(
          id: 'c7',
          title: 'First Haircut & Styling Deal',
          rewardAmount: '\$15',
          rewardSuffix: 'per appointment',
          description:
              'Refer friends to get their hair styled at CloudCuts. You earn \$15 per completed appointment.',
          endsDate: 'Ends Sep 01',
          promotersCount: '61 promoters',
          isActive: true,
        ),
      ],
    ),
  ].obs;

  List<BusinessDiscoverModel> get filteredBusinesses {
    final query = searchQuery.value.trim().toLowerCase();
    final category = selectedCategory.value;

    return businesses.where((b) {
      final matchesCategory = category == 'All' ||
          b.category.toLowerCase() == category.toLowerCase();
      final matchesQuery = query.isEmpty ||
          b.name.toLowerCase().contains(query) ||
          b.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void onSelectCategory(String category) {
    selectedCategory.value = category;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onBusinessTap(BusinessDiscoverModel business) {
    if (Get.key.currentState != null) {
      Get.toNamed(
        AppRoutes.businessDetail,
        arguments: business,
      );
    }
  }

  void onMapViewTap() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Map View',
        'Viewing 5 nearby partner businesses in San Francisco, CA',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void onFilterTap() {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Filter',
        'Filter options will allow sorting by distance, rating, and highest rewards.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;

    selectedNavIndex.value = index;
    if (index == 0 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 2 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.myReferrals);
    } else if (index == 3 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.communityFeed);
    } else if (index == 4 && Get.key.currentState != null) {
      Get.offNamed(AppRoutes.profile);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
