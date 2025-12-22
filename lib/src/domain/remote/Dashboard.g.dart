// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(


    json['totalDocuments'] as int,
  json['totalCategories'] as int,
  json['totalEvents'] as int,
  TotalStorage.fromJson(json['totalStorage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{

  'totalDocument': instance.totalDocuments,
  'totalCategories': instance.totalCategories,
  'totalEvents': instance.totalEvents,
  'totalStorage': instance.totalStorage,
};