// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) => Document(

    json['id'] as String,
  json['code'] as String,
  json['title'] as String,
  json['description'] as String,
  json['fileName'] as String,
    json['mimeType'] as String,
    json['createdAt'] as String,
    json['status'] as String,
    json['uploadedBy']??"Mame Néné BA",
    json['eventId'] as String,
    json['categoryId'] as String,
);

Map<String, dynamic> _$DocumentToJson(Document instance) => <String, dynamic>{

  'id': instance.id,
  'code': instance.code,
  'title': instance.title,
  'description': instance.description,
  'fileName': instance.fileName,
  'mimeType': instance.mimeType,
  'createdAt': instance.createdAt,
  'status': instance.status,
  'uploadedBy': instance.uploadedBy,
  'eventId' : instance.eventId,
  'categoryId' : instance.categoryId,
};