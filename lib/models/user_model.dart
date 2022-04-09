import 'dart:convert';

class UserModel {
  final String accessToken;
  UserModel({
    required this.accessToken,
  });

  UserModel copyWith({
    String? accessToken,
  }) {
    return UserModel(
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      accessToken: map['accessToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(accessToken: $accessToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.accessToken == accessToken;
  }

  @override
  int get hashCode => accessToken.hashCode;
}
