// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TotalStorage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalStorage _$TotalStorageFromJson(Map<String, dynamic> json) => TotalStorage(
      json['formatted'] as String,
      (json['totalBytes'] as num).toInt(),
    );

Map<String, dynamic> _$TotalStorageToJson(TotalStorage instance) =>
    <String, dynamic>{
      'formatted': instance.formatted,
      'totalBytes': instance.totalBytes,
    };
