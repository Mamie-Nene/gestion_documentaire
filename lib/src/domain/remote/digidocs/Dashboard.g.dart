// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
      (json['totalDocuments'] as num).toInt(),
      (json['totalCategories'] as num).toInt(),
      (json['totalEvents'] as num).toInt(),
      TotalStorage.fromJson(json['totalStorage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
      'totalDocuments': instance.totalDocuments,
      'totalCategories': instance.totalCategories,
      'totalEvents': instance.totalEvents,
      'totalStorage': instance.totalStorage,
    };
