import '../../domain/entity/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicUrl: json['profile_pic_url'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      profilePicUrl: profilePicUrl,
    );
  }
}
