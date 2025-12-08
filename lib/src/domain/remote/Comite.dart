
import 'package:json_annotation/json_annotation.dart';

part 'Comite.g.dart';

@JsonSerializable()
class Comite {
  final String id,name,created;
  final int membersCount;


  Comite(this.id, this.name, this.created,this.membersCount);

  factory Comite.fromJson(Map<String, dynamic> data)=>_$ComiteFromJson(data);
  Map<String,dynamic> toJson() => _$ComiteToJson(this);
}