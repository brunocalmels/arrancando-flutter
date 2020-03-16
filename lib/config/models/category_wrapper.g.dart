// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryWrapper _$CategoryWrapperFromJson(Map<String, dynamic> json) {
  return CategoryWrapper(
    id: json['id'] as int,
    type: _$enumDecodeNullable(_$SectionTypeEnumMap, json['type']),
    nombre: json['nombre'] as String,
  );
}

Map<String, dynamic> _$CategoryWrapperToJson(CategoryWrapper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SectionTypeEnumMap[instance.type],
      'nombre': instance.nombre,
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
