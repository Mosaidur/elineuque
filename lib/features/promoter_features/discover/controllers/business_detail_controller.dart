import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/business_discover_model.dart';
import '../models/campaign_model.dart';

class BusinessDetailController extends GetxController {
  late BusinessDiscoverModel business;
  final selectedCampaignIndex = 0.obs;
  final isLinkCopied = false.obs;

  @override
  void onInit() {
    super.onInit();

    final dynamic args = Get.arguments;
    if (args is BusinessDiscoverModel) {
      business = args;
    } else {
      // Default fallback fallback
      business = const BusinessDiscoverModel(
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
      );
    }
  }

  CampaignModel get activeCampaign {
    if (business.campaigns.isEmpty) {
      return CampaignModel(
        id: 'default',
        title: '${business.name} Campaign',
        rewardAmount: business.rewardPerReferral,
        description: 'Earn on every referral made to ${business.name}.',
        endsDate: 'Ends Soon',
        promotersCount: '${business.activePromoters} promoters',
      );
    }
    return business.campaigns[selectedCampaignIndex.value.clamp(0, business.campaigns.length - 1)];
  }

  void selectCampaign(int index) {
    selectedCampaignIndex.value = index;
  }

  Future<void> copyReferralLink() async {
    await Clipboard.setData(ClipboardData(text: business.referralLink));
    isLinkCopied.value = true;

    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Link Copied!',
        'Your referral link (${business.referralLink}) copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void shareVia(String platform) {
    if (Get.context != null && Get.key.currentState?.overlay != null) {
      Get.snackbar(
        'Share via $platform',
        'Sharing link "${business.referralLink}" with your friends on $platform...',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void previewFriendView() {
    if (Get.context == null) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF092942),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Friend's Discount QR Code",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Show this QR code at ${business.name} counter to claim first month 50% off.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 140,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Referral: ${business.referralSlug}',
              style: const TextStyle(
                color: Color(0xFFC8FF5A),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
