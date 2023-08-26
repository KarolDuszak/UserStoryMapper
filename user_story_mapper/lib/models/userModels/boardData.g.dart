// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boardData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardData _$BoardDataFromJson(Map<String, dynamic> json) => BoardData(
      boardId: json['boardId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$BoardDataToJson(BoardData instance) => <String, dynamic>{
      'boardId': instance.boardId,
      'name': instance.name,
      'description': instance.description,
    };
