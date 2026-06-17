class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? profilePicUrl;
  final int assignedProjectsCount;
  final String? accountStatus;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicUrl,
    required this.assignedProjectsCount,
    required this.accountStatus,
  });
}
