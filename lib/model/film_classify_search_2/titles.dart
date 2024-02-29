import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'titles.g.dart';

@JsonSerializable()
class Titles {
  @JsonKey(name: 'Area')
  String? area;
  @JsonKey(name: 'Category')
  String? category;
  @JsonKey(name: 'Initial')
  String? initial;
  @JsonKey(name: 'Language')
  String? language;
  @JsonKey(name: 'Plot')
  String? plot;
  @JsonKey(name: 'Sort')
  String? sort;
  @JsonKey(name: 'Year')
  String? year;

  Titles({
    this.area,
    this.category,
    this.initial,
    this.language,
    this.plot,
    this.sort,
    this.year,
  });

  factory Titles.fromJson(Map<String, dynamic> json) {
    return _$TitlesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TitlesToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Titles) return false;
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
