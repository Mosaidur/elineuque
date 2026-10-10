import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/home/controllers/my_referrals_controller.dart';
import 'package:elineuque/features/promoter_features/home/models/referral_activity_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('MyReferralsController Tests', () {
    test('MyReferralsController initializes dynamic stats and activities', () {
      final controller = MyReferralsController();
      Get.put(controller);

      expect(controller.sharedCount.value, '0');
      expect(controller.pendingCount.value, '0');
      expect(controller.convertedCount.value, '0');
      expect(controller.totalEarned.value, '\$0');
      expect(controller.thisMonthEarned.value, '+\$0');
      expect(controller.selectedNavIndex.value, 2); // Track tab is index 2
      expect(controller.activities.isEmpty, true);
    });

    test('MyReferralsController activity items have correct status labels', () {
      const itemVerified = ReferralActivityItem(
        businessName: 'Kava Brew',
        friendName: 'Alex M.',
        timeAgo: '2h ago',
        amount: '\$25',
        status: ActivityStatus.verified,
        currentStep: 3,
        icon: Icons.coffee,
        iconColor: Colors.amber,
      );
      expect(itemVerified.statusLabel, 'verified');

      const itemPending = ReferralActivityItem(
        businessName: 'Luna Spa',
        friendName: 'Sarah K.',
        timeAgo: '1d ago',
        amount: '\$15',
        status: ActivityStatus.pending,
        currentStep: 2,
        icon: Icons.spa,
        iconColor: Colors.purple,
      );
      expect(itemPending.statusLabel, 'pending');
    });
  });
}
