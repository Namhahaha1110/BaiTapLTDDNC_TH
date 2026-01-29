import 'user.dart';

class UserAccount {
  final User user;
  final String password;

  const UserAccount({required this.user, required this.password});

  Map<String, dynamic> toJson() => {
    'fullname': user.fullname,
    'email': user.email,
    'gender': user.gender,
    'favorite': user.favorite,
    'password': password,
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
    );
  }
}
