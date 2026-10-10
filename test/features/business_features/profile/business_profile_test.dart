import 'package:elineuque/features/business_features/dashboard/controllers/business_dashboard_controller.dart';
import 'package:elineuque/features/business_features/profile/controllers/business_profile_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BusinessProfileController Tests', () {
    late BusinessProfileController controller;

    setUp(() {
      controller = BusinessProfileController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('BusinessProfileController initializes clean zero stats, listing details, and empty promoters', () {
      expect(controller.selectedNavIndex, 4);
      expect(controller.businessName, '');
      expect(controller.category, 'Business');
      expect(controller.location, '');
      expect(controller.totalReferrals, 0);
      expect(controller.totalConverted, 0);
      expect(controller.totalRevenue, '\$0.0K');
      expect(controller.activePromoters.isEmpty, true);
    });

    test('BusinessProfileController synchronizes with BusinessDashboardController', () {
      final dashboard = BusinessDashboardController();
      dashboard.updateListing(
        name: 'Iron Peak Crossfit',
        category: 'Crossfit',
        hours: 'Open 24 hours',
        description: 'Elite training facility',
        rewardPerReferral: '\$60',
      );

      controller.fetchProfile(dashboard);

      expect(controller.businessName, 'Iron Peak Crossfit');
      expect(controller.category, 'Crossfit');
      expect(controller.listingHours, 'Open 24 hours');
      expect(controller.rewardPerReferral, '\$60');
    });
  });
}
