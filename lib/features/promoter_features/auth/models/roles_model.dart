import '../../../../core/enums/auth_role.dart';

class RoleOption {
  final String title;
  final String description;
  final List<String> tags;
  final bool isBusiness;
  final AuthRole role;

  const RoleOption({
    required this.title,
    required this.description,
    required this.tags,
    required this.isBusiness,
    AuthRole? role,
  }) : role = role ?? (isBusiness ? AuthRole.business : AuthRole.promoter);
}