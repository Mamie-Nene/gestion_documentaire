
import 'package:json_annotation/json_annotation.dart';

part 'Reunion.g.dart';

@JsonSerializable()
class Reunion {
  final String id,title,description,startDate,endDate,location,code;
  final int documentCount;
    final String status;
  final List<String> userGroups;



  Reunion(this.id, this.title, this.description, this.startDate,  this.endDate,this.location, this.code,this.documentCount,
       this.status , this.userGroups,
      );

  factory Reunion.fromJson(Map<String, dynamic> data)=>_$ReunionFromJson(data);
  Map<String,dynamic> toJson() => _$ReunionToJson(this);
}