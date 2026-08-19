import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/business_referral_controller.dart';
import 'widgets/referral_card_item.dart';
import 'widgets/referral_filter_tabs.dart';

class BusinessReferralScreen extends GetView<BusinessReferralController> {
  const BusinessReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Obx(
        () => BusinessBottomNav(
          selectedIndex: controller.selectedNavIndex.value,
          onItemSelected: controller.onNavTap,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              const Text(
                'Referrals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage and verify customer referrals',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),

              const SizedBox(height: 18),

              // ── Filter Tabs ([All] | [Pending] | [Verified] | [Paid]) ──
              Obx(
                () => ReferralFilterTabs(
                  selectedFilter: controller.selectedFilter.value,
                  allCount: controller.allCount,
                  pendingCount: controller.pendingCount,
                  verifiedCount: controller.verifiedCount,
                  paidCount: controller.paidCount,
                  onFilterSelected: controller.setFilter,
                ),
              ),

              const SizedBox(height: 18),

              // ── Referral Items List ──
              Obx(() {
                final list = controller.filteredReferrals;

                if (list.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: const Center(
                      child: Text(
                        'No referrals in this section.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: list.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ReferralCardItem(
                        item: item,
                        onVerify: () => controller.verifyReferral(item.id),
                        onReject: () => controller.rejectReferral(item.id),
                        onMarkPaid: () => controller.markPaid(item.id),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
