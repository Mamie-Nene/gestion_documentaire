import 'package:json_annotation/json_annotation.dart';

part 'IboardMeetingData.g.dart';

@JsonSerializable()
class IboardMeetingData {
  final String id;
  final String title;
  final String description;
  final String meetingDate;
  final int? durationMinutes;
  final String location;
  final String? meetingLink;
  final String code;
  final int documentCount;
  final List<String> userGroups;
  final String status;
  final bool isPublic;

  IboardMeetingData(
      this.id,
      this.title,
      this.description,
      this.meetingDate,
      this.durationMinutes,
      this.location,
      this.meetingLink,
      this.code,
      this.documentCount,
      this.userGroups,
      this.status,
      this.isPublic,
      );

  factory IboardMeetingData.fromJson(Map<String, dynamic> json) =>
      _$IboardMeetingDataFromJson(json);

  Map<String, dynamic> toJson() => _$IboardMeetingDataToJson(this);
}