import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'initial.g.dart';

@JsonSerializable()
class Initial {
  @JsonKey(name: 'Name')
  String? name;
  @JsonKey(name: 'Value')
  String? value;

  Initial({this.name, this.value});

  factory Initial.fromJson(Map<String, dynamic> json) {
    return _$InitialFromJson(json);
  }

  Map<String, dynamic> toJson() => _$InitialToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Initial) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
