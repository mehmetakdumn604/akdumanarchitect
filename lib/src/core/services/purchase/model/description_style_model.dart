import 'package:json_annotation/json_annotation.dart';
part 'description_style_model.g.dart';

@JsonSerializable()
class DescriptionStyleModel {
  @JsonKey(name: "color")
  final String? color;
  @JsonKey(name: "weight")
  final int? weight;
  @JsonKey(name: "fontSize")
  final int? fontSize;

  DescriptionStyleModel({
    this.color,
    this.weight,
    this.fontSize,
  });

  DescriptionStyleModel copyWith({
    String? color,
    int? weight,
    int? fontSize,
  }) =>
      DescriptionStyleModel(
        color: color ?? this.color,
        weight: weight ?? this.weight,
        fontSize: fontSize ?? this.fontSize,
      );

  factory DescriptionStyleModel.fromJson(Map<String, dynamic> json) => _$DescriptionStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionStyleModelToJson(this);
}
