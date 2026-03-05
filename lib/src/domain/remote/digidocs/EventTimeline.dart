
import 'package:json_annotation/json_annotation.dart';

part 'EventTimeline.g.dart';

@JsonSerializable()
class EventTimeline {
  final String id,event,eventTitle,description,endTime,createdAt,updatedAt;
  final String startTime;


  EventTimeline(this.id, this.event, this.eventTitle, this.description,
      this.startTime, this.endTime, this.createdAt, this.updatedAt);

  factory EventTimeline.fromJson(Map<String, dynamic> data)=>_$EventTimelineFromJson(data);
  Map<String,dynamic> toJson() => _$EventTimelineToJson(this);
}