// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(

  json['id'] as String,
  json['title'] as String,
    json['description'] as String,
  json['eventDate'] as String
  //json['categoryId'] as String,
  //(json['committeeIds'] as List).map((e) => e['committeeIds'].toString()).toList(),

);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{

  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'eventDate': instance.eventDate,
  //'categoryId': instance.categoryId,
 // 'committeeIds': instance.committeeIds
};