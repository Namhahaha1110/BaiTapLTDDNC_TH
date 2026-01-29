import 'user.dart';

class UserAccount {
  final User user;
  final String password;
  final String? avatarPath; // ✅ lưu đường dẫn ảnh

  const UserAccount({
    required this.user,
    required this.password,
    this.avatarPath,
  });

  Map<String, dynamic> toJson() => {
    'fullname': user.fullname,
    'email': user.email,
    'gender': user.gender,
    'favorite': user.favorite,
    'password': password,
    'avatarPath': avatarPath,
  };

  static UserAccount fromJson(Map<String, dynamic> json) {
    return UserAccount(
      user: User(
        fullname: json['fullname'] ?? '',
        email: json['email'] ?? '',
        gender: json['gender'] ?? 'Other',
        favorite: json['favorite'] ?? 'None',
      ),
      password: json['password'] ?? '',
      avatarPath: json['avatarPath'],
    );
  }

  UserAccount copyWith({User? user, String? password, String? avatarPath}) {
    return UserAccount(
      user: user ?? this.user,
      password: password ?? this.password,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
