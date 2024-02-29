// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_classify_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmClassifySearch _$FilmClassifySearchFromJson(Map<String, dynamic> json) =>
    FilmClassifySearch(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      page: json['page'] == null
          ? null
          : Page.fromJson(json['page'] as Map<String, dynamic>),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$FilmClassifySearchToJson(FilmClassifySearch instance) =>
    <String, dynamic>{
      'data': instance.data,
      'page': instance.page,
      'status': instance.status,
    };
