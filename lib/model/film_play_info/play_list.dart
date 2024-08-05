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
}
