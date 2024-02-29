// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmDetail _$FilmDetailFromJson(Map<String, dynamic> json) => FilmDetail(
      code: json['code'] as int?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$FilmDetailToJson(FilmDetail instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg,
    };
