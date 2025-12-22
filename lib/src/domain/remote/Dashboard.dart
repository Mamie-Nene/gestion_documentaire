
import '/src/domain/remote/TotalStorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Dashboard.g.dart';

@JsonSerializable()
class Dashboard {

  final int totalDocuments,totalCategories,totalEvents;
  final TotalStorage totalStorage;


  Dashboard(this.totalDocuments,  this.totalCategories, this.totalEvents, this.totalStorage);



  factory Dashboard.fromJson(Map<String, dynamic> data)=>_$DashboardFromJson(data);
  Map<String,dynamic> toJson() => _$DashboardToJson(this);
}