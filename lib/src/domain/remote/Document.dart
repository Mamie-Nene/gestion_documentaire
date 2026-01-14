
import 'package:json_annotation/json_annotation.dart';

part 'Document.g.dart';

@JsonSerializable()
class Document {
  final String id,code,title,description,fileName,mimeType,createdAt,status,uploadedBy,eventId,category;


  Document(this.id,  this.code, this.title, this.description,
      this.fileName, this.mimeType, this.createdAt, this.status,this.uploadedBy,this.eventId,this.category);



  factory Document.fromJson(Map<String, dynamic> data)=>_$DocumentFromJson(data);
  Map<String,dynamic> toJson() => _$DocumentToJson(this);
}