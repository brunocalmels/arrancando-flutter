import 'package:json_annotation/json_annotation.dart';

part 'point_of_interest.g.dart';

@JsonSerializable()
class PointOfInterest {
  final int id;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  String titulo;
  String cuerpo;
  double latitud;
  double longitud;
  List<String> imagenes;

  PointOfInterest(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.latitud,
    this.longitud,
    this.imagenes,
  );

  factory PointOfInterest.fromJson(Map<String, dynamic> json) =>
      _$PointOfInterestFromJson(json);

  Map<String, dynamic> toJson() => _$PointOfInterestToJson(this);

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";
}
