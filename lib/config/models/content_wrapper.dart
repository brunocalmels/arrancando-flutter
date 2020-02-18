import 'dart:typed_data';

import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/comentario.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
  double localDistance;
  String direccion;
  List<String> imagenes;
  List<Puntaje> puntajes;
  Usuario user;
  List<Comentario> comentarios;

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
    this.comentarios,
  );

  factory ContentWrapper.fromJson(Map<String, dynamic> json) =>
      _$ContentWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ContentWrapperToJson(this);

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' : '/' + createdAt.toLocal().year.toString()}";
      // "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";

  double get puntajePromedio => puntajes != null && puntajes.length > 0
      ? (puntajes.fold<double>(0, (sum, p) => sum + p.puntaje) /
          puntajes.length)
      : 0.0;

  Future<double> get distancia async {
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
          localDistance = mts;
          return mts;
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

  distanciaToH() {
    if (localDistance != null) {
      double kms = localDistance / 1000;
      if (kms < 1)
        return "${localDistance.round()}m";
      else
        return "${kms.toStringAsFixed(2)}km";
    }
    return null;
  }

  shareSelf({bool esFull = false, Uint8List imageBytes}) async {
    String cabecera =
        "Mirá esta publicación: https://arrancando.com.ar/${this.type.toString().split('.').last}/${this.id}";
    String piecera =
        "Si todavía no te descargaste Arrancando podés hacerlo desde https://play.google.com/store/apps/details?id=com.macherit.arrancando";

    String texto = esFull
        ? "$cabecera\n\n${this.titulo}\n\n${this.cuerpo}\n\n$piecera"
        : "$cabecera\n\n${this.titulo}\n\n$piecera";

    if (this.imagenes.length > 0 && imageBytes != null) {
      Share.file(
        'Compartir imagen',
        'imagen.jpg',
        imageBytes,
        'image/jpg',
        text: texto,
      );
    } else {
      var img = (await rootBundle.load('assets/images/icon.png'))
          .buffer
          .asUint8List();

      Share.file(
        'Compartir imagen',
        'imagen.jpg',
        img,
        'image/jpg',
        text: texto,
      );
    }
  }
}
