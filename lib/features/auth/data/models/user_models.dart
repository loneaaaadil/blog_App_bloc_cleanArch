import 'package:blog_app/core/common/entities/user.dart';

class UserModels extends User {
  UserModels({
    required super.id,
    required super.email,
    required super.name,
  });
  factory UserModels.fromJson(Map<String, dynamic> map) {
    return UserModels(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }
  UserModels copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserModels(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}
