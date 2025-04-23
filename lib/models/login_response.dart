import 'user_registration_model.dart';
import 'user.dart';

class LoginResponse {
  final User user;
  final UserRegistrationModel profile;

  LoginResponse({required this.user, required this.profile});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json),
      profile: UserRegistrationModel.fromJson(json['profile']),
    );
  }
}
