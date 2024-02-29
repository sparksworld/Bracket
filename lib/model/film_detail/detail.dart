import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'descriptor.dart';
import 'list.dart';
import 'play_list.dart';

part 'detail.g.dart';

@JsonSerializable()
class Detail {
  int? id;
  int? cid;
  int? pid;
  String? name;
  String? picture;
  List<String>? playFrom;
  @JsonKey(name: 'DownFrom')
  String? downFrom;
  List<List<PlayList>>? playList;
  dynamic downloadList;
  Descriptor? descriptor;
  List<OriginList>? list;

  Detail({
    this.id,
    this.cid,
    this.pid,
    this.name,
    this.picture,
    this.playFrom,
    this.downFrom,
    this.playList,
    this.downloadList,
    this.descriptor,
    this.list,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return _$DetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DetailToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Detail) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      cid.hashCode ^
      pid.hashCode ^
      name.hashCode ^
      picture.hashCode ^
      playFrom.hashCode ^
      downFrom.hashCode ^
      playList.hashCode ^
      downloadList.hashCode ^
      descriptor.hashCode ^
      list.hashCode;
}
