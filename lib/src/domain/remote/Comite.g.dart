// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comite _$ComiteFromJson(Map<String, dynamic> json) => Comite(

  json['id'] as String,
  json['name'] as String,
  json['created'] as String,
  json['membersCount'] as int

);

Map<String, dynamic> _$ComiteToJson(Comite instance) => <String, dynamic>{

  'id': instance.id,
  'name': instance.name,
  'created': instance.created,
  'membersCount': instance.membersCount
};