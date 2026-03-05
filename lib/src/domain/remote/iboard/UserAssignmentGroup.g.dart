// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAssignmentGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAssignmentGroup _$UserAssignmentGroupFromJson(Map<String, dynamic> json) =>
    UserAssignmentGroup(
          json['groupId'] as String,
          json['groupName'] as String,
          json['groupRoleId'] as String,
          json['groupRoleName'] as String,
    );

Map<String, dynamic> _$UserAssignmentGroupToJson(UserAssignmentGroup instance) =>
    <String, dynamic>{
          'groupId': instance.groupId,
          'groupName': instance.groupName,
          'groupRoleId': instance.groupRoleId,
          'groupRoleName': instance.groupRoleName,
    };
