import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/theme/theme.dart';
import '../../dashboard/views/widgets/business_bottom_nav.dart';
import '../controllers/business_referral_controller.dart';
import 'widgets/referral_card_item.dart';
import 'widgets/referral_filter_tabs.dart';

class BusinessReferralScreen extends StatefulWidget {
  const BusinessReferralScreen({super.key});

  @override
  State<BusinessReferralScreen> createState() => _BusinessReferralScreenState();
}

class _BusinessReferralScreenState extends State<BusinessReferralScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BusinessReferralController>().fetchReferrals();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BusinessReferralController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BusinessBottomNav(
        selectedIndex: 1,
        onItemSelected: (index) => controller.onNavTap(context, index),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchReferrals,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                ReferralFilterTabs(
                  selectedFilter: controller.selectedFilter,
                  allCount: controller.allCount,
                  pendingCount: controller.pendingCount,
                  verifiedCount: controller.verifiedCount,
                  paidCount: controller.paidCount,
                  onFilterSelected: controller.setFilter,
                ),

                const SizedBox(height: 16),

                // ── Referrals List / Empty state ──
                if (controller.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.businessPrimary),
                    ),
                  )
                else if (controller.filteredReferrals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No referrals found',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredReferrals.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.filteredReferrals[index];
                      return ReferralCardItem(
                        item: item,
                        onVerify: () => controller.verifyReferral(context, item.id),
                        onReject: () => controller.rejectReferral(context, item.id),
                        onMarkPaid: () => controller.markPaid(context, item.id),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
