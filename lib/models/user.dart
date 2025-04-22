class User {
  final String userName;
  //final String email;
  final String token;
  final String refreshToken;
  final DateTime tokenExpira;
  final DateTime refreshExpira;

  User({
    required this.userName,
    //required this.email,
    required this.token,
    required this.refreshToken,
    required this.tokenExpira,
    required this.refreshExpira,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    return User(
      userName: json['username'] ?? '', // fallback
      token: json['accesToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      tokenExpira: now.add(Duration(seconds: json['expiresIn'])),
      refreshExpira: now.add(Duration(seconds: json['refreshExpiresIn'])),
    );
  }
}
