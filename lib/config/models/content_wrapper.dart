import 'dart:convert';
import 'dart:typed_data';

import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/comentario.dart';
import 'package:arrancando/config/models/subcategoria_receta.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/services/permissions.dart';
import 'package:arrancando/config/state/content_page.dart';
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
  bool habilitado;
  String rubro;
  int whatsapp;
  int seguido;
  String color;
  int vistas;

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
    this.habilitado,
    this.rubro,
    this.whatsapp,
    this.seguido,
    this.color,
    this.vistas,
  );

  factory ContentWrapper.fromJson(Map<String, dynamic> json) =>
      _$ContentWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ContentWrapperToJson(this);

  String get fecha =>
      '${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' : '/' + createdAt.toLocal().year.toString()}';

  String get fechaTexto {
    final meses = <String>[
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${createdAt.toLocal().day.toString().padLeft(2, '0')} de ${meses[createdAt.toLocal().month - 1]} ${createdAt.toLocal().year == DateTime.now().year ? '' : createdAt.toLocal().year}';
  }

  // '${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}';

  int myPuntaje(int uid) =>
      puntajes
          ?.firstWhere(
            (p) => p.usuario.id == uid,
            orElse: () => null,
          )
          ?.puntaje ??
      0;

  void addMyPuntaje(Puntaje myPuntaje) {
    var oldPuntaje = puntajes?.indexWhere(
      (p) => p.usuario.id == myPuntaje.usuario.id,
    );
    if (oldPuntaje >= 0) {
      var ps = [];
      var i = 0;
      puntajes.forEach((p) {
        if (i == oldPuntaje) {
          ps.add(myPuntaje);
        } else {
          ps.add(p);
        }
        i++;
      });
      puntajes = [...ps];
    } else {
      puntajes = [
        ...puntajes,
        myPuntaje,
      ];
    }
  }

  double get puntajePromedio => puntajes != null && puntajes.isNotEmpty
      ? (puntajes.fold<double>(0, (sum, p) => sum + p.puntaje) /
          puntajes.length)
      : 0.0;

  Future<double> get distancia async {
    if (type != null && type == SectionType.pois) {
      final denied = !(await PermissionUtils.requestLocationPermission());
      if (!denied) {
        final currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        if (currentPosition != null) {
          final mts = await Geolocator.distanceBetween(
            currentPosition.latitude,
            currentPosition.longitude,
            latitud,
            longitud,
          );
          if (mts != null) {
            localDistance = mts;
            return mts;
          }
        }
      }
    }
    return null;
  }

  int get categID => type == SectionType.publicaciones
      ? ciudadId
      : type == SectionType.recetas
          ? categoriaRecetaId
          : categoriaPoiId;

  bool esOwner(
    BuildContext context,
  ) =>
      user != null &&
      context.select<UserState, ActiveUser>((value) => value.activeUser) !=
          null &&
      user.id ==
          context.select<UserState, ActiveUser>((value) => value.activeUser).id;

  String distanciaToH() {
    if (localDistance != null) {
      final kms = localDistance / 1000;
      if (kms < 1) {
        return '${localDistance.round()}m';
      } else {
        return '${kms.toStringAsFixed(2)}km';
      }
    }
    return null;
  }

  // Future<void> refetchSelf() async {
  //   String _url;

  //   switch (type) {
  //     case SectionType.publicaciones:
  //       _url = '/publicaciones';
  //       break;
  //     case SectionType.recetas:
  //       _url = '/recetas';
  //       break;
  //     case SectionType.pois:
  //       _url = '/pois';
  //       break;
  //     default:
  //       _url = '/publicaciones';
  //   }

  //   ResponseObject res = await Fetcher.get(url: '$_url/$id.json');

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

  Future<void> sharedThisContent() async {
    try {
      await Fetcher.post(
        url: '/content/shared_this.json',
        body: {
          'id': id,
          'type': type.toString().split('.').last,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> shareSelf({
    bool esFull = false,
    Uint8List imageBytes,
    bool esWpp = false,
    bool esFbk = false,
  }) async {
    var miraEsta = 'esta publicación';
    String categ;

    final gs = GlobalSingleton();

    switch (type) {
      case SectionType.publicaciones:
        miraEsta = 'esta publicación';
        break;
      case SectionType.recetas:
        miraEsta = 'esta receta';
        break;
      case SectionType.pois:
        miraEsta = 'esta tienda';
        categ = gs.categories[SectionType.pois]
            .firstWhere(
              (c) => c.id == categoriaPoiId,
              orElse: () => null,
            )
            ?.nombre;
        break;
      default:
        miraEsta = 'esta publicación';
    }

    final piecera =
        'Mirá $miraEsta: https://arrancando.com.ar/${type.toString().split('.').last}/${id}';
    // String cabecera =
    //     'Si todavía no te descargaste Arrancando podés hacerlo desde\n\nAndroid: https://play.google.com/store/apps/details?id=com.macherit.arrancando\n\niOS: https://apps.apple.com/us/app/arrancando/id1490590335?l=es';
    final cabecera = '';

    final cuerpo = this.cuerpo != null && this.cuerpo.isNotEmpty
        ? '\n\n${this.cuerpo}'
        : '';
    final introduccion = this.introduccion != null &&
            this.introduccion.isNotEmpty
        ? '\n\n${esWpp ? '*INTRODUCCIÓN*:\n' : 'INTRODUCCIÓN:\n'}${this.introduccion}'
        : '';
    final ingredientes = ingredientesItems != null &&
            ingredientesItems.isNotEmpty
        ? '\n\n${esWpp ? '*INGREDIENTES*:\n' : 'INGREDIENTES:\n'}${ingredientesItems.map((i) => '${i['cantidad']} ${i['unidad']} de ${i['ingrediente']}').join('\n')}'
        : this.ingredientes != null && this.ingredientes.isNotEmpty
            ? '\n\n${esWpp ? '*INGREDIENTES*:\n' : 'INGREDIENTES:\n'}${this.ingredientes}'
            : '';
    final instrucciones = this.instrucciones != null &&
            this.instrucciones.isNotEmpty
        ? '\n\n${esWpp ? '*INSTRUCCIONES*:\n' : 'INSTRUCCIONES:\n'}${this.instrucciones}'
        : '';

    final titulo = esWpp ? '*${this.titulo}*' : this.titulo;

    final categoria = categ != null ? 'Categoría: $categ\n\n' : '';

    final texto = esFull
        ? '$cabecera\n\n$piecera\n\n$categoria$titulo$cuerpo$introduccion$ingredientes$instrucciones'
        : '$cabecera\n\n$categoria$titulo\n\n$piecera';

    if (esFbk) {
      Share.text(
        'Compartir contenido',
        'https://arrancando.com.ar/${type.toString().split('.').last}/${id}',
        'text/plain',
      );
    } else {
      if (imageBytes != null) {
        await Share.file(
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

        await Share.file(
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
    ContentSortType sortBy,
    BuildContext context,
  }) async {
    final mainState = context.read<MainState>();
    final userState = context.read<UserState>();
    final contentPageState = context.read<ContentPageState>();

    var rootURL = '/publicaciones';
    var categoryParamName = 'ciudad_id';

    switch (type) {
      case SectionType.publicaciones:
        rootURL = '/publicaciones';
        categoryParamName = 'ciudad_id';
        break;
      case SectionType.recetas:
        rootURL = '/recetas';
        categoryParamName = 'categoria_receta_id';
        break;
      case SectionType.pois:
        rootURL = '/pois';
        categoryParamName = 'categoria_poi_id';
        break;
      default:
    }

    var url = '$rootURL.json?page=$page';

    if (search != null && search.isNotEmpty) {
      url +=
          '&filterrific[search_query]=${Uri.encodeComponent(search.replaceAll('@', ''))}';
    }
    if (categoryId != null && categoryId > 0) {
      url += '&filterrific[$categoryParamName]=$categoryId';
    }

    if (type == SectionType.publicaciones &&
        context != null &&
        mainState.selectedCategoryHome[SectionType.publicaciones_categoria] !=
            null &&
        mainState.selectedCategoryHome[SectionType.publicaciones_categoria] >
            0) {
      url +=
          '&filterrific[categoria_publicacion_id]=${mainState.selectedCategoryHome[SectionType.publicaciones_categoria]}';
    }

    if (type == SectionType.pois &&
        context != null &&
        mainState.selectedCategoryHome[SectionType.pois_ciudad] != null &&
        mainState.selectedCategoryHome[SectionType.pois_ciudad] > 0) {
      url +=
          '&filterrific[ciudad_id]=${mainState.selectedCategoryHome[SectionType.pois_ciudad]}';
    }

    if (context != null &&
        contentPageState.showMine[type] != null &&
        contentPageState.showMine[type]) {
      url += '&filterrific[user_id]=${userState.activeUser.id}';
    }

    if (sortBy != null) {
      switch (sortBy) {
        case ContentSortType.fecha_creacion:
          url += '&filterrific[sorted_by]=fecha_creacion';
          break;
        case ContentSortType.fecha_actualizacion:
          url += '&filterrific[sorted_by]=fecha_actualizacion';
          break;
        case ContentSortType.puntuacion:
          url += '&filterrific[sorted_by]=puntuacion';
          break;
        case ContentSortType.proximidad:
          url += '&filterrific[sorted_by]=proximidad';
          break;
        case ContentSortType.vistas:
          url += '&filterrific[sorted_by]=vistas';
          break;
        default:
      }
    }

    final resp = await Fetcher.get(
      url: url,
    );

    if (resp != null) {
      return (json.decode(resp.body) as List)
          .map(
            (p) {
              var content = ContentWrapper.fromJson(p);
              content.type = type;
              return content;
            },
          )
          .where(
            (p) => p.habilitado == null || p.habilitado,
          )
          .toList();
    }

    return [];
  }

  static Future<List<ContentWrapper>> sortItems(
    List<ContentWrapper> elements,
    ContentSortType type, {
    Map<int, double> calculatedDistance,
  }) async {
    final items = elements;
    try {
      switch (type) {
        case ContentSortType.proximidad:
          if (calculatedDistance != null &&
              (await PermissionUtils.requestLocationPermission())) {
            await Future.wait(
              items.map(
                (i) async {
                  if (calculatedDistance[i.id] == null) {
                    await i.distancia;
                  } else {
                    i.localDistance = calculatedDistance[i.id];
                  }
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

  Future<void> setSaved(bool val) async {
    var url;
    switch (type) {
      case SectionType.publicaciones:
        url = '/publicaciones';
        break;
      case SectionType.recetas:
        url = '/recetas';
        break;
      case SectionType.pois:
        url = '/pois';
        break;
      default:
        url = '/publicaciones';
    }

    await Fetcher.put(
      url: '$url/$id/saved.json',
      body: {
        'saved': val,
      },
    );
  }
}
