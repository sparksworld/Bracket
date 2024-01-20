// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFilm _$SearchFilmFromJson(Map<String, dynamic> json) => SearchFilm(
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$SearchFilmToJson(SearchFilm instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
    };
