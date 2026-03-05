class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final int gender;
  final List<String> hobbies;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.gender,
    required this.hobbies,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      gender: (map['gender'] ?? 0) as int,
      hobbies: (map['hobbies'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'gender': gender,
      'hobbies': hobbies,
    };
  }
}
