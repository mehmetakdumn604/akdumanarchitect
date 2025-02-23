import 'package:json_annotation/json_annotation.dart';

import 'description_style_model.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
   String? productId;
   String? title;
   String? description;
  
  final DescriptionStyleModel? titleStyle;
  final DescriptionStyleModel? descriptionStyle;

  Product({
    this.productId,
    this.title,
    this.description,
    this.titleStyle,
    this.descriptionStyle,
  });

  Product copyWith({
    String? productId,
    String? title,
    String? description,
    DescriptionStyleModel? titleStyle,
    DescriptionStyleModel? descriptionStyle,
  }) =>
      Product(
        productId: productId ?? this.productId,
        title: title ?? this.title,
        description: description ?? this.description,
        titleStyle: titleStyle ?? this.titleStyle,
        descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      );

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

      
}
