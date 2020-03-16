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
    json['instrucciones'] as String,
    (json['latitud'] as num)?.toDouble(),
    (json['longitud'] as num)?.toDouble(),
    json['direccion'] as String,
    json['ciudad_id'] as int,
    json['categoria_receta_id'] as int,
    json['categoria_poi_id'] as int,
    json['categoria_publicacion_id'] as int,
    (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
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
  )..localDistance = (json['localDistance'] as num)?.toDouble();
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
      'instrucciones': instance.instrucciones,
      'ciudad_id': instance.ciudadId,
      'categoria_receta_id': instance.categoriaRecetaId,
      'categoria_poi_id': instance.categoriaPoiId,
      'categoria_publicacion_id': instance.categoriaPublicacionId,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'localDistance': instance.localDistance,
      'direccion': instance.direccion,
      'imagenes': instance.imagenes,
      'thumbnail': instance.thumbnail,
      'puntajes': instance.puntajes,
      'user': instance.user,
      'comentarios': instance.comentarios,
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
};
