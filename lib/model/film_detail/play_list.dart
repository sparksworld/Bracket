import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'play_list.g.dart';

@JsonSerializable()
class PlayList {
  String? episode;
  String? link;

  PlayList({this.episode, this.link});

  factory PlayList.fromJson(Map<String, dynamic> json) {
    return _$PlayListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlayListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PlayList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => episode.hashCode ^ link.hashCode;
}
