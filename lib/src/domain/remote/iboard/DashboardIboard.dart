
import '../digidocs/TotalStorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DashboardIboard.g.dart';

@JsonSerializable()
class DashboardIboard {

  final int totalMeetings,totalMembers,totalAdoptedResolutions;
  final String groupName;


  DashboardIboard( this.groupName, this.totalMeetings,  this.totalMembers, this.totalAdoptedResolutions);



  factory DashboardIboard.fromJson(Map<String, dynamic> data)=>_$DashboardFromJson(data);
  Map<String,dynamic> toJson() => _$DashboardToJson(this);
}