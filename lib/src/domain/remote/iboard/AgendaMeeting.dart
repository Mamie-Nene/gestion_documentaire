import 'package:json_annotation/json_annotation.dart';

part 'AgendaMeeting.g.dart';

@JsonSerializable()
class AgendaMeeting {
  final String id;
  final String meetingCode;
  final String meetingTitle;
  final String description;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;

  AgendaMeeting(
      this.id,
      this.meetingCode,
      this.meetingTitle,
      this.description,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.updatedAt,
      );

  factory AgendaMeeting.fromJson(Map<String, dynamic> json) =>
      _$AgendaMeetingFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaMeetingToJson(this);
}