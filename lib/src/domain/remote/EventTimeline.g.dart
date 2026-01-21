// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventTimeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventTimeline _$EventTimelineFromJson(Map<String, dynamic> json) => EventTimeline(


  json['id'] as String,
  json['event'] as String,
  json['eventTitle'] as String,
    json['description'] as String,
  json['startTime'] as String ,
  json['endTime']??"AUCUN" ,
  json['createdAt'] as String,
  json['updatedAt'] as String,


);

Map<String, dynamic> _$EventTimelineToJson(EventTimeline instance) => <String, dynamic>{

  'id': instance.id,
  'eventTitle': instance.eventTitle,
  'description': instance.description,
  'startTime': instance.startTime,
  'event': instance.event,
};