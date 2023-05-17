// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roleLabel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleLabel _$RoleLabelFromJson(Map<String, dynamic> json) => RoleLabel(
      id: json['id'] as String,
      color: $enumDecode(_$ColorLabelEnumMap, json['color']),
      title: json['title'] as String,
    );

Map<String, dynamic> _$RoleLabelToJson(RoleLabel instance) => <String, dynamic>{
      'id': instance.id,
      'color': _$ColorLabelEnumMap[instance.color]!,
      'title': instance.title,
    };

const _$ColorLabelEnumMap = {
  ColorLabel.green: 'green',
  ColorLabel.purple: 'purple',
  ColorLabel.grey: 'grey',
  ColorLabel.blue: 'blue',
  ColorLabel.black: 'black',
};
