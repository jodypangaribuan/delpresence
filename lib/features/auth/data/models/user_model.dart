class UserModel {
  final int id;
  final String nimNip;
  final String name;
  final String email;
  final String userType;
  final bool verified;

  UserModel({
    required this.id,
    required this.nimNip,
    required this.name,
    required this.email,
    required this.userType,
    required this.verified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'] as int,
        nimNip: json['nim_nip'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        userType: json['user_type'] as String,
        verified: json['verified'] as bool,
      );
    } catch (e) {
      print('Error parsing UserModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nim_nip': nimNip,
      'name': name,
      'email': email,
      'user_type': userType,
      'verified': verified,
    };
  }
}
