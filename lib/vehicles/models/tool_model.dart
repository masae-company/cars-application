import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_model.freezed.dart';
part 'tool_model.g.dart';

@freezed
class ToolModel with _$ToolModel {
  const factory ToolModel({
    required String id,
    required String name,
    @JsonKey(name: 'owner_id') required String ownerId,
    String? image,
    String? description,
    String? category,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ToolModel;

  factory ToolModel.fromJson(Map<String, dynamic> json) =>
      _$ToolModelFromJson(json);
}

