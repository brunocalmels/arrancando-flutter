import 'dart:convert';
import 'dart:typed_data';

import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/comentario.dart';
import 'package:arrancando/config/models/subcategoria_receta.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
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
  String introduccion;
  String ingredientes;
  @JsonKey(name: 'ingredientes_items')
  List<Map> ingredientesItems;
  String instrucciones;
  @JsonKey(name: 'ciudad_id')
  int ciudadId;
  @JsonKey(name: 'categoria_receta_id')
  int categoriaRecetaId;
  @JsonKey(name: 'subcategoria_recetas')
  List<SubcategoriaReceta> subcategoriaRecetas;
  @JsonKey(name: 'categoria_poi_id')
  int categoriaPoiId;
  @JsonKey(name: 'categoria_publicacion_id')
  int categoriaPublicacionId;
  double latitud;
  double longitud;
  double localDistance;
  String direccion;
  List<String> imagenes;
  @JsonKey(name: 'video_thumbs')
  Map<String, String> videoThumbs;
  String thumbnail;
  List<Puntaje> puntajes;
  Usuario user;
  List<Comentario> comentarios;
  int duracion; // De cocción
  String complejidad; // De preparación

  ContentWrapper(
    this.id,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.introduccion,
    this.ingredientes,
    this.ingredientesItems,
    this.instrucciones,
    this.latitud,
    this.longitud,
    this.direccion,
    this.ciudadId,
    this.categoriaRecetaId,
    this.categoriaPoiId,
    this.categoriaPublicacionId,
    this.imagenes,
    this.videoThumbs,
    this.thumbnail,
    this.puntajes,
    this.user,
    this.comentarios,
    this.duracion,
    this.complejidad,
  );

  factory ContentWrapper.fromJson(Map<String, dynamic> json) =>
      _$ContentWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ContentWrapperToJson(this);

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' : '/' + createdAt.toLocal().year.toString()}";

  String get fechaTexto {
    final List<String> meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre",
    ];
    return "${createdAt.toLocal().day.toString().padLeft(2, '0')} de ${meses[createdAt.toLocal().month - 1]} ${createdAt.toLocal().year == DateTime.now().year ? '' : createdAt.toLocal().year}";
  }

  // "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";

  int myPuntaje(int uid) =>
      puntajes
          ?.firstWhere(
            (p) => p.usuario.id == uid,
            orElse: () => null,
          )
          ?.puntaje ??
      0;

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
      this.user.id == Provider.of<UserState>(context).activeUser.id;

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

  // Future<void> refetchSelf() async {
  //   String _url;

  //   switch (type) {
  //     case SectionType.publicaciones:
  //       _url = "/publicaciones";
  //       break;
  //     case SectionType.recetas:
  //       _url = "/recetas";
  //       break;
  //     case SectionType.pois:
  //       _url = "/pois";
  //       break;
  //     default:
  //       _url = "/publicaciones";
  //   }

  //   ResponseObject res = await Fetcher.get(url: "$_url/$id.json");

  //   if (res != null && res.body != null) {
  //     ContentWrapper newContent =
  //         ContentWrapper.fromJson(json.decode(res.body));
  //     updatedAt = newContent.updatedAt;
  //     titulo = newContent.titulo;
  //     cuerpo = newContent.cuerpo;
  //     introduccion = newContent.introduccion;
  //     ingredientes = newContent.ingredientes;
  //     instrucciones = newContent.instrucciones;
  //     latitud = newContent.latitud;
  //     longitud = newContent.longitud;
  //     direccion = newContent.direccion;
  //     ciudadId = newContent.ciudadId;
  //     categoriaRecetaId = newContent.categoriaRecetaId;
  //     categoriaPoiId = newContent.categoriaPoiId;
  //     categoriaPublicacionId = newContent.categoriaPublicacionId;
  //     imagenes = newContent.imagenes;
  //     videoThumbs = newContent.videoThumbs;
  //     thumbnail = newContent.thumbnail;
  //     puntajes = newContent.puntajes;
  //     user = newContent.user;
  //     comentarios = newContent.comentarios;
  //     duracion = newContent.duracion;
  //     complejidad = newContent.complejidad;
  //   }
  // }

  shareSelf({
    bool esFull = false,
    Uint8List imageBytes,
    bool esWpp = false,
    bool esFbk = false,
  }) async {
    String miraEsta = "esta publicación";

    switch (type) {
      case SectionType.publicaciones:
        miraEsta = "esta publicación";
        break;
      case SectionType.recetas:
        miraEsta = "esta receta";
        break;
      case SectionType.pois:
        miraEsta = "este Pto. de interés";
        break;
      default:
        miraEsta = "esta publicación";
    }

    String piecera =
        "Mirá $miraEsta: https://arrancando.com.ar/${this.type.toString().split('.').last}/${this.id}";
    // String cabecera =
    //     "Si todavía no te descargaste Arrancando podés hacerlo desde\n\nAndroid: https://play.google.com/store/apps/details?id=com.macherit.arrancando\n\niOS: https://apps.apple.com/us/app/arrancando/id1490590335?l=es";
    String cabecera = "";

    String cuerpo = this.cuerpo != null && this.cuerpo.isNotEmpty
        ? "\n\n${this.cuerpo}"
        : "";
    String introduccion = this.introduccion != null &&
            this.introduccion.isNotEmpty
        ? "\n\n${esWpp ? '*INTRODUCCIÓN*:\n' : 'INTRODUCCIÓN:\n'}${this.introduccion}"
        : "";
    String ingredientes = this.ingredientesItems != null &&
            this.ingredientesItems.isNotEmpty
        ? "\n\n${esWpp ? '*INGREDIENTES*:\n' : 'INGREDIENTES:\n'}${this.ingredientesItems.map((i) => "${i['cantidad']} ${i['unidad']} de ${i['ingrediente']}").join('\n')}"
        : this.ingredientes != null && this.ingredientes.isNotEmpty
            ? "\n\n${esWpp ? '*INGREDIENTES*:\n' : 'INGREDIENTES:\n'}${this.ingredientes}"
            : "";
    String instrucciones = this.instrucciones != null &&
            this.instrucciones.isNotEmpty
        ? "\n\n${esWpp ? '*INSTRUCCIONES*:\n' : 'INSTRUCCIONES:\n'}${this.instrucciones}"
        : "";

    String titulo = esWpp ? "*${this.titulo}*" : this.titulo;

    String texto = esFull
        ? "$cabecera\n\n$piecera\n\n$titulo$cuerpo$introduccion$ingredientes$instrucciones"
        : "$cabecera\n\n$titulo\n\n$piecera";

    if (esFbk) {
      Share.text(
        "Compartir contenido",
        "https://arrancando.com.ar/${this.type.toString().split('.').last}/${this.id}",
        "text/plain",
      );
    } else {
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

  static Future<List<ContentWrapper>> fetchItems(
    SectionType type, {
    String search,
    int page = 0,
    int categoryId,
    BuildContext context,
    ContentSortType sortBy,
  }) async {
    String rootURL = '/publicaciones';
    String categoryParamName = "ciudad_id";

    switch (type) {
      case SectionType.publicaciones:
        rootURL = '/publicaciones';
        categoryParamName = "ciudad_id";
        break;
      case SectionType.recetas:
        rootURL = '/recetas';
        categoryParamName = "categoria_receta_id";
        break;
      case SectionType.pois:
        rootURL = '/pois';
        categoryParamName = "categoria_poi_id";
        break;
      default:
    }

    String url = "$rootURL.json?page=$page";

    if (search != null && search.isNotEmpty)
      url += "&filterrific[search_query]=$search";
    if (categoryId != null && categoryId > 0)
      url += "&filterrific[$categoryParamName]=$categoryId";

    if (type == SectionType.publicaciones &&
        context != null &&
        Provider.of<MainState>(context)
                .selectedCategoryHome[SectionType.publicaciones_categoria] !=
            null &&
        Provider.of<MainState>(context)
                .selectedCategoryHome[SectionType.publicaciones_categoria] >
            0)
      url +=
          '&filterrific[categoria_publicacion_id]=${Provider.of<MainState>(context).selectedCategoryHome[SectionType.publicaciones_categoria]}';

    if (type == SectionType.pois &&
        context != null &&
        Provider.of<MainState>(context)
                .selectedCategoryHome[SectionType.pois_ciudad] !=
            null &&
        Provider.of<MainState>(context)
                .selectedCategoryHome[SectionType.pois_ciudad] >
            0)
      url +=
          '&filterrific[ciudad_id]=${Provider.of<MainState>(context).selectedCategoryHome[SectionType.pois_ciudad]}';

    if (sortBy != null)
      switch (sortBy) {
        case ContentSortType.fecha:
          url += '&filterrific[sorted_by]=fecha';
          break;
        case ContentSortType.puntuacion:
          url += '&filterrific[sorted_by]=puntuacion';
          break;
        case ContentSortType.proximidad:
          url += '&filterrific[sorted_by]=proximidad';
          break;
        default:
      }

    ResponseObject resp = await Fetcher.get(
      url: url,
    );

    if (resp != null) {
      return (json.decode(resp.body) as List).map(
        (p) {
          var content = ContentWrapper.fromJson(p);
          content.type = type;
          return content;
        },
      ).toList();
    }

    return [];
  }

  static Future<List<ContentWrapper>> sortItems(
    List<ContentWrapper> elements,
    ContentSortType type, {
    Map<int, double> calculatedDistance,
  }) async {
    List<ContentWrapper> items = elements;
    try {
      switch (type) {
        case ContentSortType.proximidad:
          if (calculatedDistance != null &&
              !(await ActiveUser.locationPermissionDenied())) {
            await Future.wait(
              items.map(
                (i) async {
                  if (calculatedDistance[i.id] == null)
                    await i.distancia;
                  else
                    i.localDistance = calculatedDistance[i.id];
                  return null;
                },
              ),
            );
            items?.sort((a, b) => a.localDistance != null &&
                    b.localDistance != null &&
                    a.localDistance < b.localDistance
                ? -1
                : 1);
          }
          break;
        default:
      }
      return items;
    } catch (e) {
      print(e);
    }
    return [];
  }
}
