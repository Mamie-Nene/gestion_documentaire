// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(

  json['id'] as String,
  json['title'] as String,
    json['description'] as String,
  json['startDate'] as String ,
  json['endDate']??"AUCUN" ,
  json['location'] as String,
  json['code'] as String,
  json['documentCount'] as int,
  json['status'] as String,
 // List<String>.from(userGroups.map((item) => item as String))
  (json['userGroups'] as List).map((e) => e.toString()).toList(),


);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{

  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'eventDate': instance.startDate,
  'location': instance.location,
  'documentCount': instance.documentCount,
  'status': instance.status,
  'userGroups': instance.userGroups
};