import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'link_list.dart';

part 'list.g.dart';

@JsonSerializable()
class OriginList {
  String? id;
  String? name;
  List<LinkList>? linkList;

  OriginList({this.id, this.name, this.linkList});

  factory OriginList.fromJson(Map<String, dynamic> json) =>
      _$OriginListFromJson(json);

  Map<String, dynamic> toJson() => _$OriginListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! OriginList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ linkList.hashCode;
}
