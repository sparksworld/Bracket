import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'year.g.dart';

@JsonSerializable()
class Year {
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Value')
  String? value;

  Year({this.name, this.value});

  factory Year.fromJson(Map<String, dynamic> json) => _$YearFromJson(json);

  Map<String, dynamic> toJson() => _$YearToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Year) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
