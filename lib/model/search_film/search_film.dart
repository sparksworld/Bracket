import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'search_film.g.dart';

@JsonSerializable()
class SearchFilm {
  Data? data;
  String? status;

  SearchFilm({this.data, this.status});

  factory SearchFilm.fromJson(Map<String, dynamic> json) {
    return _$SearchFilmFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SearchFilmToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SearchFilm) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => data.hashCode ^ status.hashCode;
}
