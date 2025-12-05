// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(

    json['id'] as String,
  json['name'] as String,
  json['code'] as String,
  json['title'] as String,
  json['description'] as String,
  json['fileName'] as String,
    json['mimeType'] as String,
    json['createdAt'] as String,
    json['status'] as bool
);

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{

  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'title': instance.title,
  'description': instance.description,
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'createdAt': instance.createdAt,
  'status': instance.status
};