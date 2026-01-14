
import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfo {
  final String id,firstName,lastName,email,dateCreation,role;
  final List<String> userGroups;


  UserInfo(this.id, this.firstName, this.lastName, this.email, this.dateCreation,this.role,
      this.userGroups);

  factory UserInfo.fromJson(Map<String, dynamic> data)=>_$UserInfoFromJson(data);
  Map<String,dynamic> toJson() => _$UserInfoToJson(this);
}