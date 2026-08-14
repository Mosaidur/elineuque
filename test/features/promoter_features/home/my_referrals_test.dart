import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/home/controllers/my_referrals_controller.dart';
import 'package:elineuque/features/promoter_features/home/models/referral_activity_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('MyReferralsController Tests', () {
    test('MyReferralsController initializes stats and activity items', () {
      final controller = MyReferralsController();
      Get.put(controller);

      expect(controller.sharedCount.value, '92');
      expect(controller.pendingCount.value, '14');
      expect(controller.convertedCount.value, '78');
      expect(controller.totalEarned.value, '\$1,840');
      expect(controller.thisMonthEarned.value, '+\$420');

      expect(controller.selectedNavIndex.value, 2); // Track tab is index 2
      expect(controller.activities.length, 5);

      final fitZone = controller.activities.firstWhere((a) => a.businessName == 'FitZone Gym');
      expect(fitZone.status, ActivityStatus.paid);
      expect(fitZone.currentStep, 4);

      final tacoFusion = controller.activities.firstWhere((a) => a.businessName == 'TacoFusion');
      expect(tacoFusion.status, ActivityStatus.shared);
      expect(tacoFusion.currentStep, 1);
      expect(tacoFusion.canShareAgain, true);
    });

    test('MyReferralsController activity items have correct status labels', () {
      final controller = MyReferralsController();
      Get.put(controller);

      final kavaBrew = controller.activities.firstWhere((a) => a.businessName == 'Kava Brew');
      expect(kavaBrew.statusLabel, 'verified');

      final lunaSpa = controller.activities.firstWhere((a) => a.businessName == 'Luna Spa');
      expect(lunaSpa.statusLabel, 'pending');
    });
  });
}
