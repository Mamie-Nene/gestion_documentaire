
import 'package:json_annotation/json_annotation.dart';

part 'Document.g.dart';

@JsonSerializable()
class Document {
  final String id,name,code,title,description,fileName,mimeType,createdAt;

  bool status;


  Document(this.id, this.name, this.code, this.title, this.description,
      this.fileName, this.mimeType, this.createdAt, this.status);

  factory Document.fromJson(Map<String, dynamic> data)=>_$DocumentFromJson(data);
  Map<String,dynamic> toJson() => _$DocumentToJson(this);
}