import 'package:json_annotation/json_annotation.dart';

part 'list.g.dart';

@JsonSerializable()
class ListData {
  String? id;
  String? name;

  ListData({
    this.id,
    this.name,
  });

  factory ListData.fromJson(Map<String, dynamic> json) =>
      _$ListDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListDataToJson(this);
}
