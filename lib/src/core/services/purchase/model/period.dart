import 'package:json_annotation/json_annotation.dart';

import 'description_style_model.dart';

part 'period.g.dart';

@JsonSerializable()
class Period {
  @JsonKey(name: "text")
  final String? text;
  @JsonKey(name: "style")
  final DescriptionStyleModel? style;
  @JsonKey(name: "product")
  final String? product;

  Period({
    this.text,
    this.style,
    this.product,
  });

  Period copyWith({
    String? text,
    DescriptionStyleModel? style,
    String? product,
  }) =>
      Period(
        text: text ?? this.text,
        style: style ?? this.style,
        product: product ?? this.product,
      );

  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}
