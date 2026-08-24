// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolModelImpl _$$ToolModelImplFromJson(Map<String, dynamic> json) =>
    _$ToolModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['owner_id'] as String,
      image: json['image'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ToolModelImplToJson(_$ToolModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'owner_id': instance.ownerId,
      'image': instance.image,
      'description': instance.description,
      'category': instance.category,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
