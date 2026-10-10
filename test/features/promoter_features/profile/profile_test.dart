import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:elineuque/features/promoter_features/profile/controllers/profile_controller.dart';
import 'package:elineuque/features/promoter_features/profile/models/leaderboard_user_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('ProfileController Tests', () {
    test('ProfileController initializes default user details and stats', () {
      final controller = ProfileController();
      Get.put(controller);

      expect(controller.selectedNavIndex.value, 4);
      expect(controller.isEditing.value, false);
      expect(controller.fullName.value, 'Promoter');
      expect(controller.handle.value, '@promoter');
      expect(controller.earnedAmount.value, '\$0');
      expect(controller.totalReferrals.value, 0);
      expect(controller.convertedCount.value, 0);
      expect(controller.availableWallet.value, '\$0.00');
    });

    test('ProfileController opens and cancels edit mode', () {
      final controller = ProfileController();
      Get.put(controller);

      controller.openEdit();
      expect(controller.isEditing.value, true);
      expect(controller.fullNameCtrl.text, 'Promoter');

      controller.cancelEdit();
      expect(controller.isEditing.value, false);
    });

    test('ProfileController saves profile modifications', () async {
      final controller = ProfileController();
      Get.put(controller);

      controller.openEdit();
      controller.fullNameCtrl.text = 'Rifat Hossain';
      controller.handleCtrl.text = 'rifathossain';
      await controller.saveProfile();

      expect(controller.isEditing.value, false);
      expect(controller.fullName.value, 'Rifat Hossain');
      expect(controller.handle.value, '@rifathossain');
    });

    test('ProfileController initializes badges and leaderboard', () {
      final controller = ProfileController();
      Get.put(controller);

      expect(controller.badges.length, 6);
      expect(controller.leaderboard.isEmpty, true);

      controller.leaderboard.add(const LeaderboardUserModel(
        rank: 1,
        name: 'You',
        initials: 'Y',
        avatarColor: Color(0xFF5365F5),
        referralsCount: 78,
        earnings: '\$1,840',
        isCurrentUser: true,
      ));
      expect(controller.leaderboard.length, 1);
      expect(controller.leaderboard.firstWhere((u) => u.isCurrentUser).name, 'You');
    });
  });
}
