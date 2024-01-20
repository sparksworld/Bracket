import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'page.dart';
import 'list.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: 'list')
  List<VideoList>? list;
  Page? page;

  Data({this.list, this.page});

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
  int get hashCode => list.hashCode ^ page.hashCode;
}
