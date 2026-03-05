// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AgendaMeeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaMeeting _$AgendaMeetingFromJson(Map<String, dynamic> json) =>
    AgendaMeeting(
      json['id'] as String,
      json['meetingCode'] as String,
      json['meetingTitle'] as String,
      json['description'] as String,
      json['startTime'] as String,
      json['endTime'] as String,
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$AgendaMeetingToJson(AgendaMeeting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingCode': instance.meetingCode,
      'meetingTitle': instance.meetingTitle,
      'description': instance.description,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
