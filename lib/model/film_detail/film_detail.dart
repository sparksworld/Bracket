import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'film_detail.g.dart';

@JsonSerializable()
class FilmDetail {
  int? code;
  Data? data;
  String? msg;

  FilmDetail({this.code, this.data, this.msg});

  factory FilmDetail.fromJson(Map<String, dynamic> json) {
    return _$FilmDetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FilmDetailToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! FilmDetail) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => code.hashCode ^ data.hashCode ^ msg.hashCode;
}
