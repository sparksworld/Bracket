import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detail.dart';
import 'relate.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  Detail? detail;
  List<Relate>? relate;

  Data({this.detail, this.relate});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Data) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => detail.hashCode ^ relate.hashCode;
}
