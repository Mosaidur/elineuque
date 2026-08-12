import 'package:elineuque/features/promoter_features/auth/views/widgets/role_selecting_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/theme.dart';
import '../controllers/role_select_controller.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 45),

                    Image.asset(
                      'assets/images/only_elivapp_logo.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Join Elivapp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Choose how you want to use the platform',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ...controller.roles.map(
                          (role) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: RoleCard(
                          role: role,
                          onTap: () {
                            controller.selectRole(role);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}