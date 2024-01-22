import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable()
class VideoList {
  int? id;
  int? cid;
  int? pid;
  String? name;
  String? subTitle;
  String? cName;
  String? state;
  String? picture;
  String? actor;
  String? director;
  String? blurb;
  String? remarks;
  String? area;
  String? year;

  VideoList({
    this.id,
    this.cid,
    this.pid,
    this.name,
    this.subTitle,
    this.cName,
    this.state,
    this.picture,
    this.actor,
    this.director,
    this.blurb,
    this.remarks,
    this.area,
    this.year,
  });

  factory VideoList.fromJson(Map<String, dynamic> json) {
    return _$VideoListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VideoListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      cid.hashCode ^
      pid.hashCode ^
      name.hashCode ^
      subTitle.hashCode ^
      cName.hashCode ^
      state.hashCode ^
      picture.hashCode ^
      actor.hashCode ^
      director.hashCode ^
      blurb.hashCode ^
      remarks.hashCode ^
      area.hashCode ^
      year.hashCode;
}
