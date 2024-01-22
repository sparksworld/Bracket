// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) => Page(
      pageSize: json['pageSize'] as int?,
      current: json['current'] as int?,
      pageCount: json['pageCount'] as int?,
      total: json['total'] as int?,
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'pageSize': instance.pageSize,
      'current': instance.current,
      'pageCount': instance.pageCount,
      'total': instance.total,
    };
