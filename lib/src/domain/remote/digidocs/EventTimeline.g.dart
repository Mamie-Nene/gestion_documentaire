// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventTimeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventTimeline _$EventTimelineFromJson(Map<String, dynamic> json) =>
    EventTimeline(
      json['id'] as String,
      json['event'] as String,
      json['eventTitle'] as String,
      json['description'] as String,
      json['startTime'] as String,
      json['endTime'] as String,
      json['createdAt'] as String,
      json['updatedAt'] as String,
    );

Map<String, dynamic> _$EventTimelineToJson(EventTimeline instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event': instance.event,
      'eventTitle': instance.eventTitle,
      'description': instance.description,
      'endTime': instance.endTime,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'startTime': instance.startTime,
    };
