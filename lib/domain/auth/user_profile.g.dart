// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
      id: json['id'] as String?,
      urlSafeKey: json['url_safe_key'] as String?,
      version: (json['version'] as num?)?.toInt() ?? 0,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone_number'] as String?,
      username: json['username'] as String?,
      authKey: json['auth_key'] as String?,
    );

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url_safe_key': instance.urlSafeKey,
      'version': instance.version,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone_number': instance.phone,
      'username': instance.username,
      'auth_key': instance.authKey,
    };
