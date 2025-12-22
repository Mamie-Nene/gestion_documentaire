
import 'package:json_annotation/json_annotation.dart';

part 'TotalStorage.g.dart';

@JsonSerializable()
class TotalStorage {
  final String formatted;
  final int totalBytes;


  TotalStorage(this.formatted, this.totalBytes);

  factory TotalStorage.fromJson(Map<String, dynamic> data)=>_$TotalStorageFromJson(data);
  Map<String,dynamic> toJson() => _$TotalStorageToJson(this);
}