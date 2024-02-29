import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'link_list.g.dart';

@JsonSerializable()
class LinkList {
  String? episode;
  String? link;

  LinkList({this.episode, this.link});

  factory LinkList.fromJson(Map<String, dynamic> json) {
    return _$LinkListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LinkListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LinkList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => episode.hashCode ^ link.hashCode;
}
