import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'email') required String email,

    // Optional at sign-up; fill later if needed
    @JsonKey(name: 'phone_number') String? phone,
    @JsonKey(name: 'username') String? username,

    // You set this after Firebase creates the account
    @JsonKey(name: 'auth_key') String? authKey,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
