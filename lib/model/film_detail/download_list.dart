import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'download_list.g.dart';

@JsonSerializable()
class DownloadList {
  String? episode;
  String? link;

  DownloadList({this.episode, this.link});

  factory DownloadList.fromJson(Map<String, dynamic> json) {
    return _$DownloadListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DownloadListToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DownloadList) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => episode.hashCode ^ link.hashCode;
}
