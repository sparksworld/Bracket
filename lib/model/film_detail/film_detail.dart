import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'film_detail.g.dart';

@JsonSerializable()
class FilmDetail {
  Data? data;
  String? status;

  FilmDetail({this.data, this.status});

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
  int get hashCode => data.hashCode ^ status.hashCode;
}
