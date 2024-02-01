import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class History {
  int? id;
  int? timeStamp;
  String? name;

  History({this.id, this.timeStamp, this.name});

  factory History.fromJson(Map<String, dynamic> json) {
    return _$HistoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
