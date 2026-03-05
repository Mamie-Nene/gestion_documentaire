// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DashboardIboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardIboard _$DashboardFromJson(Map<String, dynamic> json) => DashboardIboard(
      json['groupName'] as String,
      json['totalMeetings'] as int,
      json['totalMembers'] as int,
      json['totalAdoptedResolutions'] as int,
    );

Map<String, dynamic> _$DashboardToJson(DashboardIboard instance) => <String, dynamic>{

  'groupName': instance.groupName,
  'totalMeetings': instance.totalMeetings,
  'totalMembers': instance.totalMembers,
  'totalAdoptedResolutions': instance.totalAdoptedResolutions,
    };
