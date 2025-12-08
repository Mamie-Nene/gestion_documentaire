
import 'package:json_annotation/json_annotation.dart';

part 'Event.g.dart';

@JsonSerializable()
class Event {
  final String id,title,description,eventDate;
    //  categoryId;
  //final List<String> committeeIds;



  Event(this.id, this.title, this.description, this.eventDate,
      // this.categoryId , this.committeeIds
      );

  factory Event.fromJson(Map<String, dynamic> data)=>_$EventFromJson(data);
  Map<String,dynamic> toJson() => _$EventToJson(this);
}