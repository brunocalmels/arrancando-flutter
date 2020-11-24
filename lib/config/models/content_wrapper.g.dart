// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentWrapper _$ContentWrapperFromJson(Map<String, dynamic> json) {
  return ContentWrapper(
    json['id'] as int,
    _$enumDecodeNullable(_$SectionTypeEnumMap, json['type']),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['titulo'] as String,
    json['cuerpo'] as String,
    json['introduccion'] as String,
    json['ingredientes'] as String,
    (json['ingredientes_items'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    json['instrucciones'] as String,
    (json['latitud'] as num)?.toDouble(),
    (json['longitud'] as num)?.toDouble(),
    json['direccion'] as String,
    json['ciudad_id'] as int,
    json['categoria_receta_id'] as int,
    json['categoria_poi_id'] as int,
    json['categoria_publicacion_id'] as int,
    (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
    (json['video_thumbs'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    json['thumbnail'] as String,
    (json['puntajes'] as List)
        ?.map((e) =>
            e == null ? null : Puntaje.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['user'] == null
        ? null
        : Usuario.fromJson(json['user'] as Map<String, dynamic>),
    (json['comentarios'] as List)
        ?.map((e) =>
            e == null ? null : Comentario.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['duracion'] as int,
    json['complejidad'] as String,
    json['habilitado'] as bool,
    json['rubro'] as String,
    json['whatsapp'] as int,
    json['seguido'] as int,
    json['color'] as String,
    json['vistas'] as int,
  )
    ..subcategoriaRecetas = (json['subcategoria_recetas'] as List)
        ?.map((e) => e == null
            ? null
            : SubcategoriaReceta.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..localDistance = (json['localDistance'] as num)?.toDouble();
}

Map<String, dynamic> _$ContentWrapperToJson(ContentWrapper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SectionTypeEnumMap[instance.type],
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'introduccion': instance.introduccion,
      'ingredientes': instance.ingredientes,
      'ingredientes_items': instance.ingredientesItems,
      'instrucciones': instance.instrucciones,
      'ciudad_id': instance.ciudadId,
      'categoria_receta_id': instance.categoriaRecetaId,
      'subcategoria_recetas': instance.subcategoriaRecetas,
      'categoria_poi_id': instance.categoriaPoiId,
      'categoria_publicacion_id': instance.categoriaPublicacionId,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'localDistance': instance.localDistance,
      'direccion': instance.direccion,
      'imagenes': instance.imagenes,
      'video_thumbs': instance.videoThumbs,
      'thumbnail': instance.thumbnail,
      'puntajes': instance.puntajes,
      'user': instance.user,
      'comentarios': instance.comentarios,
      'duracion': instance.duracion,
      'complejidad': instance.complejidad,
      'habilitado': instance.habilitado,
      'rubro': instance.rubro,
      'whatsapp': instance.whatsapp,
      'seguido': instance.seguido,
      'color': instance.color,
      'vistas': instance.vistas,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SectionTypeEnumMap = {
  SectionType.home: 'home',
  SectionType.publicaciones_categoria: 'publicaciones_categoria',
  SectionType.publicaciones: 'publicaciones',
  SectionType.recetas: 'recetas',
  SectionType.pois: 'pois',
  SectionType.pois_ciudad: 'pois_ciudad',
  SectionType.wiki: 'wiki',
  SectionType.followed: 'followed',
};
