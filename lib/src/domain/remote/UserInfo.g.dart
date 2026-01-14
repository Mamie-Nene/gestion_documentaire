// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(

  json['id'] as String,
  json['firstName'] as String,
  json['lastName'] as String,
  json['email'] as String,
  json['dateCreation'] as String,
  json['role'] as String,
    ( json['userGroups'] as List).map((e) => e as String).toList()

);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{

  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'dateCreation': instance.dateCreation,
  'role': instance.role,
  'userGroups': instance.userGroups
};