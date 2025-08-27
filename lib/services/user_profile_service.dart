import 'dart:convert';

import 'package:you_owe_us/domain/auth/user_profile.dart';
import 'package:you_owe_us/services/base_service.dart';

class UserProfileService extends BaseService{
  Future<UserProfile> getUserProfileByUID(String uid) async {
    var resp = await webService.getJsonResponse('user/uid/$uid');

    dynamic jsonDto = json.decode(resp);
    var dto = UserProfile.fromJson(jsonDto);

    return dto;
  }
}