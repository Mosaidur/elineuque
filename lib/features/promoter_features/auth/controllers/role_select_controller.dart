import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../core/enums/auth_role.dart';
import '../models/roles_model.dart';

class RoleSelectionController extends GetxController {
  final roles = const [
    RoleOption(
      title: 'Promoter / Referrer',
      description:
          'Share businesses with your network and earn real cash rewards for every successful referral.',
      tags: [
        'Earn rewards',
        'Share referrals',
        'Leaderboards',
      ],
      isBusiness: false,
      role: AuthRole.promoter,
    ),
    RoleOption(
      title: 'Business Owner',
      description:
          'Create campaigns → promoters share your link → scan QR when customer buys → pay reward.',
      tags: [
        'Create campaigns',
        'QR verification',
        'Pay per purchase',
      ],
      isBusiness: true,
      role: AuthRole.business,
    ),
  ];

  void selectRole(RoleOption role) {
    Get.toNamed(
      AppRoutes.signIn,
      arguments: role.role,
    );
  }
}