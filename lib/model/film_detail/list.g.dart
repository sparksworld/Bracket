// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OriginList _$OriginListFromJson(Map<String, dynamic> json) => OriginList(
      id: json['id'] as String?,
      name: json['name'] as String?,
      linkList: (json['linkList'] as List<dynamic>?)
          ?.map((e) => LinkList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OriginListToJson(OriginList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'linkList': instance.linkList,
    };
