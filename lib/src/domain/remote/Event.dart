
import 'package:json_annotation/json_annotation.dart';

part 'Event.g.dart';

@JsonSerializable()
class Event {
  final String id,title,description,startDate,endDate,location,code;
  final int documentCount;
    final String status;
  final List<String> userGroups;



  Event(this.id, this.title, this.description, this.startDate,  this.endDate,this.location, this.code,this.documentCount,
       this.status , this.userGroups,
      );

  factory Event.fromJson(Map<String, dynamic> data)=>_$EventFromJson(data);
  Map<String,dynamic> toJson() => _$EventToJson(this);
}