import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'descriptor.g.dart';

@JsonSerializable()
class Descriptor {
  String? subTitle;
  String? cName;
  String? enName;
  String? initial;
  String? classTag;
  String? actor;
  String? director;
  String? writer;
  String? blurb;
  String? remarks;
  String? releaseDate;
  String? area;
  String? language;
  String? year;
  String? state;
  String? updateTime;
  int? addTime;
  int? dbId;
  String? dbScore;
  int? hits;
  String? content;

  Descriptor({
    this.subTitle,
    this.cName,
    this.enName,
    this.initial,
    this.classTag,
    this.actor,
    this.director,
    this.writer,
    this.blurb,
    this.remarks,
    this.releaseDate,
    this.area,
    this.language,
    this.year,
    this.state,
    this.updateTime,
    this.addTime,
    this.dbId,
    this.dbScore,
    this.hits,
    this.content,
  });

  factory Descriptor.fromJson(Map<String, dynamic> json) {
    return _$DescriptorFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DescriptorToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Descriptor) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      subTitle.hashCode ^
      cName.hashCode ^
      enName.hashCode ^
      initial.hashCode ^
      classTag.hashCode ^
      actor.hashCode ^
      director.hashCode ^
      writer.hashCode ^
      blurb.hashCode ^
      remarks.hashCode ^
      releaseDate.hashCode ^
      area.hashCode ^
      language.hashCode ^
      year.hashCode ^
      state.hashCode ^
      updateTime.hashCode ^
      addTime.hashCode ^
      dbId.hashCode ^
      dbScore.hashCode ^
      hits.hashCode ^
      content.hashCode;
}
