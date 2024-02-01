// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      id: json['id'] as int?,
      timeStamp: json['timeStamp'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'id': instance.id,
      'timeStamp': instance.timeStamp,
      'name': instance.name,
    };
