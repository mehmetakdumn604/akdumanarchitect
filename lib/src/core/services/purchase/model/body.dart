import 'package:json_annotation/json_annotation.dart';

import 'button.dart';
import 'content.dart';
import 'product.dart';

part 'body.g.dart';

@JsonSerializable()
class Body {
  @JsonKey(name: "content")
  final Content? content;
  @JsonKey(name: "buttons")
  final List<Button>? buttons;

  @JsonKey(name: "products")
  final List<Product>? products;
  @JsonKey(name: "backgroundColor")
  final String? backgroundColor;

  Body({
    this.content,
    this.buttons,
    this.backgroundColor,
    this.products,
  });

  Body copyWith({
    Content? content,
    List<Button>? buttons,
    String? backgroundColor,
  }) =>
      Body(
        content: content ?? this.content,
        buttons: buttons ?? this.buttons,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

  Map<String, dynamic> toJson() => _$BodyToJson(this);
}
