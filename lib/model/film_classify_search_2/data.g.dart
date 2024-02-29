// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => VideoList.fromJson(e as Map<String, dynamic>))
          .toList(),
      params: json['params'] == null
          ? null
          : Params.fromJson(json['params'] as Map<String, dynamic>),
      search: json['search'] == null
          ? null
          : Search.fromJson(json['search'] as Map<String, dynamic>),
      title: json['title'] == null
          ? null
          : Title.fromJson(json['title'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'list': instance.list,
      'params': instance.params,
      'search': instance.search,
      'title': instance.title,
    };
