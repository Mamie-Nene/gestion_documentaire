// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ParticipantReunion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantReunion _$ParticipantReunionFromJson(Map<String, dynamic> json) =>
    ParticipantReunion(
      json['id'] as String,
      json['user'] as String,
      json['roleUser'] as String,
      json['present'] as bool,
      json['meetingAccepted'] as bool,
      json['signature'] as String?,
    );

Map<String, dynamic> _$ParticipantReunionToJson(ParticipantReunion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'roleUser': instance.roleUser,
      'present': instance.present,
      'meetingAccepted': instance.meetingAccepted,
      'signature': instance.signature,
    };
