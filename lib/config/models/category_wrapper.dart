import 'package:json_annotation/json_annotation.dart';
import 'package:arrancando/config/globals/enums.dart';

part 'category_wrapper.g.dart';

@JsonSerializable()
class CategoryWrapper {
  final int id;
  final SectionType type;
  String nombre;

  CategoryWrapper({
    this.id,
    this.type,
    this.nombre,
  });

  factory CategoryWrapper.fromJson(Map<String, dynamic> json) =>
      _$CategoryWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryWrapperToJson(this);
}
