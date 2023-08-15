// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'potentialUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PotentialUser _$PotentialUserFromJson(Map<String, dynamic> json) =>
    PotentialUser(
      id: json['id'] as String,
      color: $enumDecode(_$ColorLabelEnumMap, json['color']),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$PotentialUserToJson(PotentialUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'color': _$ColorLabelEnumMap[instance.color]!,
      'name': instance.name,
      'description': instance.description,
    };

const _$ColorLabelEnumMap = {
  ColorLabel.green: 'green',
  ColorLabel.purple: 'purple',
  ColorLabel.grey: 'grey',
  ColorLabel.blue: 'blue',
  ColorLabel.black: 'black',
};
