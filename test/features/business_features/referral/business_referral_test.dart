import 'package:elineuque/features/business_features/referral/controllers/business_referral_controller.dart';
import 'package:elineuque/features/business_features/referral/models/business_referral_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BusinessReferralController Tests', () {
    late BusinessReferralController controller;

    setUp(() {
      controller = BusinessReferralController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('BusinessReferralController initializes with empty referrals and zero counts', () {
      expect(controller.selectedFilter, 'all');
      expect(controller.selectedNavIndex, 1);
      expect(controller.allCount, 0);
      expect(controller.pendingCount, 0);
      expect(controller.verifiedCount, 0);
      expect(controller.paidCount, 0);
      expect(controller.filteredReferrals.isEmpty, true);
    });

    test('BusinessReferralController filters referrals correctly when populated', () {
      controller.referrals = [
        const BusinessReferralModel(
          id: 'ref-1',
          promoterName: 'Devon R.',
          customerName: 'Sarah K.',
          timeAgo: '1h ago',
          rewardAmount: 40,
          status: BusinessReferralStatus.verified,
          promoterInitials: 'DR',
        ),
        const BusinessReferralModel(
          id: 'ref-2',
          promoterName: 'Alicia M.',
          customerName: 'Tom M.',
          timeAgo: '3h ago',
          rewardAmount: 40,
          status: BusinessReferralStatus.pending,
          promoterInitials: 'AM',
        ),
        const BusinessReferralModel(
          id: 'ref-3',
          promoterName: 'Jordan T.',
          customerName: 'Jen P.',
          timeAgo: '5h ago',
          rewardAmount: 40,
          status: BusinessReferralStatus.verified,
          promoterInitials: 'JT',
        ),
        const BusinessReferralModel(
          id: 'ref-4',
          promoterName: 'Devon R.',
          customerName: 'Carlos S.',
          timeAgo: '1d ago',
          rewardAmount: 40,
          status: BusinessReferralStatus.paid,
          promoterInitials: 'DR',
        ),
        const BusinessReferralModel(
          id: 'ref-5',
          promoterName: 'Simone V.',
          customerName: 'Amy L.',
          timeAgo: '2d ago',
          rewardAmount: 40,
          status: BusinessReferralStatus.rejected,
          promoterInitials: 'SV',
        ),
      ];

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
  });
}
