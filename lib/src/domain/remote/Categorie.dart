
import 'package:json_annotation/json_annotation.dart';

part 'Categorie.g.dart';

@JsonSerializable()
class Categorie {
  final String id,name,code,insigne,description,createdAt;
  final int documentCount;


  Categorie(this.id, this.name, this.code, this.insigne, this.description,this.createdAt,
      this.documentCount);

  factory Categorie.fromJson(Map<String, dynamic> data)=>_$CategorieFromJson(data);
  Map<String,dynamic> toJson() => _$CategorieToJson(this);
}