import 'package:elineuque/features/business_features/referral/controllers/business_referral_controller.dart';
import 'package:elineuque/features/business_features/referral/models/business_referral_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BusinessReferralController Tests', () {
    late BusinessReferralController controller;

    setUp(() {
      Get.testMode = true;
      Get.reset();
      controller = BusinessReferralController();
    });

    test('BusinessReferralController initializes with default referrals and counts', () {
      expect(controller.selectedFilter.value, 'all');
      expect(controller.selectedNavIndex.value, 1);
      expect(controller.allCount, 5);
      expect(controller.pendingCount, 1);
      expect(controller.verifiedCount, 2);
      expect(controller.paidCount, 1);
      expect(controller.filteredReferrals.length, 5);
    });

    test('BusinessReferralController filters referrals correctly', () {
      controller.setFilter('pending');
      expect(controller.filteredReferrals.length, 1);
      expect(controller.filteredReferrals.first.id, 'ref-2');

      controller.setFilter('verified');
      expect(controller.filteredReferrals.length, 2);

      controller.setFilter('paid');
      expect(controller.filteredReferrals.length, 1);
      expect(controller.filteredReferrals.first.status, BusinessReferralStatus.paid);

      controller.setFilter('all');
      expect(controller.filteredReferrals.length, 5);
    });

    test('BusinessReferralController verifies a pending referral', () {
      controller.verifyReferral('ref-2');

      final verifiedItem = controller.referrals.firstWhere((r) => r.id == 'ref-2');
      expect(verifiedItem.status, BusinessReferralStatus.verified);
      expect(controller.pendingCount, 0);
      expect(controller.verifiedCount, 3);
    });

    test('BusinessReferralController rejects a pending referral', () {
      controller.rejectReferral('ref-2');

      final rejectedItem = controller.referrals.firstWhere((r) => r.id == 'ref-2');
      expect(rejectedItem.status, BusinessReferralStatus.rejected);
      expect(controller.pendingCount, 0);
    });

    test('BusinessReferralController marks a verified referral as paid', () {
      controller.markPaid('ref-1');

      final paidItem = controller.referrals.firstWhere((r) => r.id == 'ref-1');
      expect(paidItem.status, BusinessReferralStatus.paid);
      expect(controller.paidCount, 2);
      expect(controller.verifiedCount, 1);
    });

    test('BusinessReferralController updates nav index', () {
      controller.onNavTap(2);
      expect(controller.selectedNavIndex.value, 2);
    });
  });
}
