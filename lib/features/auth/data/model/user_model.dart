import '../../domain/entity/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicUrl;
  final int assignedProjectsCount;
  final String? accountStatus;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicUrl,
    required this.assignedProjectsCount,
    required this.accountStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicUrl: json['profile_pic_url'],
      assignedProjectsCount: json['assigned_projects_count'],
      accountStatus: json['account_status'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      profilePicUrl: profilePicUrl,
      assignedProjectsCount: assignedProjectsCount,
      accountStatus: accountStatus
    );
  }
}
