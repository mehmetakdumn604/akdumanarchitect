var buttonModel =
    """import 'package:makdumanarchitect/src/core/services/purchase/model/button_style.dart';

import 'package:json_annotation/json_annotation.dart';

part 'button.g.dart';

@JsonSerializable()
class Button {
  @JsonKey(name: "text")
  String? text;
  @JsonKey(name: "style")
  final ButtonStyle? style;
  @JsonKey(name: "product")
  final String? product;

  Button({
    this.text,
    this.style,
    this.product,
  });

  Button copyWith({
    String? text,
    ButtonStyle? style,
    String? product,
  }) =>
      Button(
        text: text ?? this.text,
        style: style ?? this.style,
        product: product ?? this.product,
      );

  factory Button.fromJson(Map<String, dynamic> json) => _\$ButtonFromJson(json);

  Map<String, dynamic> toJson() => _\$ButtonToJson(this);
}
""";
