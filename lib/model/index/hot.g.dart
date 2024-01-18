// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hot _$HotFromJson(Map<String, dynamic> json) => Hot(
      id: json['ID'] as int?,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'],
      mid: json['mid'] as int?,
      cid: json['cid'] as int?,
      pid: json['pid'] as int?,
      name: json['name'] as String?,
      subTitle: json['subTitle'] as String?,
      cName: json['CName'] as String?,
      classTag: json['classTag'] as String?,
      area: json['area'] as String?,
      language: json['language'] as String?,
      year: json['year'] as int?,
      initial: json['initial'] as String?,
      score: json['score'] as int?,
      updateStamp: json['updateStamp'] as int?,
      hits: json['hits'] as int?,
      state: json['state'] as String?,
      remarks: json['remarks'] as String?,
      releaseStamp: json['releaseStamp'] as int?,
    );

Map<String, dynamic> _$HotToJson(Hot instance) => <String, dynamic>{
      'ID': instance.id,
      'CreatedAt': instance.createdAt,
      'UpdatedAt': instance.updatedAt,
      'DeletedAt': instance.deletedAt,
      'mid': instance.mid,
      'cid': instance.cid,
      'pid': instance.pid,
      'name': instance.name,
      'subTitle': instance.subTitle,
      'CName': instance.cName,
      'classTag': instance.classTag,
      'area': instance.area,
      'language': instance.language,
      'year': instance.year,
      'initial': instance.initial,
      'score': instance.score,
      'updateStamp': instance.updateStamp,
      'hits': instance.hits,
      'state': instance.state,
      'remarks': instance.remarks,
      'releaseStamp': instance.releaseStamp,
    };
