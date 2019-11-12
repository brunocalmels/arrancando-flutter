import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/puntaje.dart';
import 'package:provider/provider.dart';

part 'content_wrapper.g.dart';

@JsonSerializable()
class ContentWrapper {
  final int id;
  SectionType type;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  String titulo;
  String cuerpo;
  @JsonKey(name: 'ciudad_id')
  int ciudadId;
  @JsonKey(name: 'categoria_receta_id')
  int categoriaRecetaId;
  @JsonKey(name: 'categoria_poi_id')
  int categoriaPoiId;
  double latitud;
  double longitud;
  String direccion;
  List<String> imagenes;
  List<Puntaje> puntajes;
  Usuario user;

  ContentWrapper(
    this.id,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.latitud,
    this.longitud,
    this.direccion,
    this.ciudadId,
    this.categoriaRecetaId,
    this.categoriaPoiId,
    this.imagenes,
    this.puntajes,
    this.user,
  );

  factory ContentWrapper.fromJson(Map<String, dynamic> json) =>
      _$ContentWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ContentWrapperToJson(this);

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";

  get puntajePromedio => puntajes != null && puntajes.length > 0
      ? (puntajes.fold<double>(0, (sum, p) => sum + p.puntaje) /
          puntajes.length)
      : 0.0;

  get distancia async {
    if (type != null && type == SectionType.pois) {
      bool denied = await ActiveUser.locationPermissionDenied();
      if (!denied) {
        Position currentPosition = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        double mts = await Geolocator().distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            this.latitud,
            this.longitud);
        if (mts != null) {
          double kms = mts / 1000;
          if (kms < 1)
            return "${mts.round()}mts";
          else
            return "${kms.toStringAsFixed(2)}kms";
        }
      }
    }
    return null;
  }

  get categID => type == SectionType.publicaciones
      ? ciudadId
      : type == SectionType.recetas ? categoriaRecetaId : categoriaPoiId;

  esOwner(BuildContext context) =>
      this.user.id == Provider.of<MyState>(context).activeUser.id;
}
