import 'package:flutter_test/flutter_test.dart';
import 'package:elineuque/features/business_features/dashboard/controllers/business_dashboard_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BusinessDashboardController Tests', () {
    test('BusinessDashboardController initializes default stats and lists', () {
      final controller = BusinessDashboardController();

      expect(controller.selectedNavIndex, 0);
      expect(controller.businessName, 'My Business');
      expect(controller.totalReferrals, 0);
      expect(controller.conversionsCount, 0);
      expect(controller.revenueDrivenK, 0.0);
      expect(controller.rewardsPaidAmount, 0);

      expect(controller.weeklyData.length, 7);
      expect(controller.recentActivities.length, 0);
    });

    test('BusinessDashboardController updates listing', () {
      final controller = BusinessDashboardController();

      controller.updateListing(
        name: 'Apex Club',
        category: 'Gym',
        hours: '24/7',
        description: 'Best gym',
        rewardPerReferral: '\$50',
      );

      expect(controller.businessName, 'Apex Club');
      expect(controller.listingName, 'Apex Club');
      expect(controller.listingCategory, 'Gym');
      expect(controller.listingHours, '24/7');
      expect(controller.rewardPerReferral, '\$50');
    });
  });
}
