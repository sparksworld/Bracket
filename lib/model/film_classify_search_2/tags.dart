import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'area.dart';
import 'category.dart';
import 'initial.dart';
import 'language.dart';
import 'plot.dart';
import 'sort.dart';
import 'year.dart';

part 'tags.g.dart';

@JsonSerializable()
class Tags {
  @JsonKey(name: 'Area')
  List<Area>? area;
  @JsonKey(name: 'Category')
  List<Category>? category;
  @JsonKey(name: 'Initial')
  List<Initial>? initial;
  @JsonKey(name: 'Language')
  List<Language>? language;
  @JsonKey(name: 'Plot')
  List<Plot>? plot;
  @JsonKey(name: 'Sort')
  List<Sort>? sort;
  @JsonKey(name: 'Year')
  List<Year>? year;

  Tags({
    this.area,
    this.category,
    this.initial,
    this.language,
    this.plot,
    this.sort,
    this.year,
  });

  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);

  Map<String, dynamic> toJson() => _$TagsToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Tags) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      area.hashCode ^
      category.hashCode ^
      initial.hashCode ^
      language.hashCode ^
      plot.hashCode ^
      sort.hashCode ^
      year.hashCode;
}
