import 'dart:convert';

import 'package:you_owe_us/domain/auth/user_profile.dart';
import 'package:you_owe_us/services/base_service.dart';

class UserProfileService extends BaseService {
  UserProfileService([super.web]);

  Future<UserProfile?> getUserProfileByUID(String uid) async {
    final resp = await webService.getJsonResponse('userprofile/uid/$uid');
    final map = jsonDecode(resp) as Map<String, dynamic>;
    return UserProfile.fromJson(map);
  }

  Future<UserProfile> saveUserProfile(UserProfile profile) async {
    final resp = await webService.postJson('userprofile', body: profile.toJson());
    final map = jsonDecode(resp) as Map<String, dynamic>;
    return UserProfile.fromJson(map);
  }
}
