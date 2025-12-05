// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Categorie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categorie _$CategorieFromJson(Map<String, dynamic> json) => Categorie(

  json['id'] as String,
  json['name'] as String,
  json['code'] as String,
  json['insigne'] as String,
  json['description'] as String,
  json['documentCount'] as int

);

Map<String, dynamic> _$CategorieToJson(Categorie instance) => <String, dynamic>{

  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'insigne': instance.insigne,
  'description': instance.description,
  'documentCount': instance.documentCount
};