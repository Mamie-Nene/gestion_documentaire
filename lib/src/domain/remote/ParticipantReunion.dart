import 'package:json_annotation/json_annotation.dart';

part 'ParticipantReunion.g.dart';

@JsonSerializable()
class ParticipantReunion {
  final String id;
  final String user;
  final String roleUser;
  final bool present;
  final bool meetingAccepted;
  final String? signature;

  ParticipantReunion(
      this.id,
      this.user,
      this.roleUser,
      this.present,
      this.meetingAccepted,
      this.signature,
      );

  factory ParticipantReunion.fromJson(Map<String, dynamic> json) =>
      _$ParticipantReunionFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantReunionToJson(this);
}