import 'package:json_annotation/json_annotation.dart';

import 'description_style_model.dart';

part 'description.g.dart';

@JsonSerializable()
class Description {
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "style")
  final DescriptionStyleModel? style;

  Description({
    this.text,
    this.style,
  });

  Description copyWith({
    String? text,
    DescriptionStyleModel? style,
  }) =>
      Description(
        text: text ?? this.text,
        style: style ?? this.style,
      );

  factory Description.fromJson(Map<String, dynamic> json) => _$DescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$DescriptionToJson(this);
}
