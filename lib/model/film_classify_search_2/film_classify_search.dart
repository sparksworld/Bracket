import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data.dart';
import 'page.dart';

part 'film_classify_search.g.dart';

@JsonSerializable()
class FilmClassifySearch {
  Data? data;
  Page? page;
  String? status;

  FilmClassifySearch({this.data, this.page, this.status});

  factory FilmClassifySearch.fromJson(Map<String, dynamic> json) {
    return _$FilmClassifySearchFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FilmClassifySearchToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! FilmClassifySearch) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => data.hashCode ^ page.hashCode ^ status.hashCode;
}
