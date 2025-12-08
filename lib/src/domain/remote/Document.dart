
import 'package:json_annotation/json_annotation.dart';

part 'Document.g.dart';

@JsonSerializable()
class Document {
  final String id,code,title,description,fileName,mimeType,createdAt,status,eventId,categoryId;


  Document(this.id,  this.code, this.title, this.description,
      this.fileName, this.mimeType, this.createdAt, this.status,this.eventId,this.categoryId);



  factory Document.fromJson(Map<String, dynamic> data)=>_$DocumentFromJson(data);
  Map<String,dynamic> toJson() => _$DocumentToJson(this);
}