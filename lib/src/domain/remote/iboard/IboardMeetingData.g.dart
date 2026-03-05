// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IboardMeetingData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IboardMeetingData _$IboardMeetingDataFromJson(Map<String, dynamic> json) =>
    IboardMeetingData(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['meetingDate'] as String,
      (json['durationMinutes'] as num?)?.toInt(),
      json['location'] as String,
      json['meetingLink'] as String?,
      json['code'] as String,
      (json['documentCount'] as num).toInt(),
      (json['userGroups'] as List<dynamic>).map((e) => e as String).toList(),
      json['status'] as String,
      json['isPublic'] as bool,
    );

Map<String, dynamic> _$IboardMeetingDataToJson(IboardMeetingData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'meetingDate': instance.meetingDate,
      'durationMinutes': instance.durationMinutes,
      'location': instance.location,
      'meetingLink': instance.meetingLink,
      'code': instance.code,
      'documentCount': instance.documentCount,
      'userGroups': instance.userGroups,
      'status': instance.status,
      'isPublic': instance.isPublic,
    };
