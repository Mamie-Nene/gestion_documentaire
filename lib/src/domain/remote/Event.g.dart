// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as String,
      json['title'] as String,
      json['description'] as String,
      json['startDate'] as String,
      json['endDate'] as String,
      json['location'] as String,
      json['code'] as String,
      (json['documentCount'] as num).toInt(),
      json['status'] as String,
      (json['userGroups'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'location': instance.location,
      'code': instance.code,
      'documentCount': instance.documentCount,
      'status': instance.status,
      'userGroups': instance.userGroups,
    };
