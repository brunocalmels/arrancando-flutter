import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/puntaje.dart';

class ContentWrapper {
  final int id;
  final SectionType type;
  DateTime createdAt;
  DateTime updatedAt;
  String titulo;
  String cuerpo;
  int ciudadId;
  double latitud;
  double longitud;
  List<String> imagenes;
  List<Puntaje> puntajes;

  ContentWrapper({
    this.id,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.latitud,
    this.longitud,
    this.ciudadId,
    this.imagenes,
    this.puntajes,
  });

  factory ContentWrapper.fromOther(dynamic other, SectionType type) {
    Map<String, dynamic> json = (other is Map) ? other : other.toJson();
    return ContentWrapper(
      id: json['id'] as int,
      type: type,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      titulo: json['titulo'] as String,
      cuerpo: json['cuerpo'] as String,
      latitud: (json['latitud'] as num)?.toDouble(),
      longitud: (json['longitud'] as num)?.toDouble(),
      imagenes: (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
      puntajes: (json['puntajes'] as List)
          ?.map((e) =>
              e == null ? null : Puntaje.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";

  get puntajePromedio => puntajes.length > 0
      ? (puntajes.fold<double>(0, (sum, p) => sum + p.puntaje) /
          puntajes.length)
      : 0;
}
