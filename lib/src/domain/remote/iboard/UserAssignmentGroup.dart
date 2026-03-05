import 'package:json_annotation/json_annotation.dart';

part 'UserAssignmentGroup.g.dart';

@JsonSerializable()
class UserAssignmentGroup {
  final String groupId;
  final String groupName;
  final String groupRoleId;
  final String groupRoleName;

  UserAssignmentGroup(
      this.groupId,
      this.groupName,
      this.groupRoleId,
      this.groupRoleName
      );

  factory UserAssignmentGroup.fromJson(Map<String, dynamic> json) =>
      _$UserAssignmentGroupFromJson(json);

  Map<String, dynamic> toJson() => _$UserAssignmentGroupToJson(this);
}