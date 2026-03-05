import 'package:gestion_documentaire/src/domain/remote/iboard/ParticipantReunion.dart';
import 'package:json_annotation/json_annotation.dart';


part 'FeuillePresence.g.dart';

@JsonSerializable(explicitToJson: true)
class FeuillePresence {
  final String id;
  final String meetingCode;
  final String createdAt;
  final String dateReunion;
  final String userGroups;
  final List<ParticipantReunion> participants;

  FeuillePresence(
      this.id,
      this.meetingCode,
      this.createdAt,
      this.dateReunion,
      this.userGroups,
      this.participants,
      );

  factory FeuillePresence.fromJson(Map<String, dynamic> json) =>
      _$FeuillePresenceFromJson(json);

  Map<String, dynamic> toJson() => _$FeuillePresenceToJson(this);
}