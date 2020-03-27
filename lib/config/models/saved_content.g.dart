// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedContent _$SavedContentFromJson(Map<String, dynamic> json) {
  return SavedContent(
    json['id'] as int,
    _$enumDecodeNullable(_$SectionTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$SavedContentToJson(SavedContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SectionTypeEnumMap[instance.type],
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
};
