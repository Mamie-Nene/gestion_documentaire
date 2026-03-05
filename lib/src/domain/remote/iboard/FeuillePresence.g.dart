// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FeuillePresence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeuillePresence _$FeuillePresenceFromJson(Map<String, dynamic> json) =>
    FeuillePresence(
      json['id'] as String,
      json['meetingCode'] as String,
      json['createdAt'] as String,
      json['dateReunion'] as String,
      json['userGroups'] as String,
      (json['participants'] as List<dynamic>)
          .map((e) => ParticipantReunion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeuillePresenceToJson(FeuillePresence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingCode': instance.meetingCode,
      'createdAt': instance.createdAt,
      'dateReunion': instance.dateReunion,
      'userGroups': instance.userGroups,
      'participants': instance.participants.map((e) => e.toJson()).toList(),
    };
