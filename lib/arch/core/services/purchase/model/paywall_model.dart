var paywallModel ="""import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

import 'body.dart';
import 'configurations.dart';
import 'footer.dart';
import 'header.dart';

part 'paywall_model.g.dart';

@JsonSerializable()
class PaywallModel {
  @JsonKey(name: "header")
  Header? header;
  @JsonKey(name: "body")
  Body? body;
  @JsonKey(name: "footer")
  Footer? footer;
  @JsonKey(name: "configurations")
  Configurations? configurations;

  PaywallModel({
    this.header,
    this.body,
    this.footer,
    this.configurations,
  });

  PaywallModel copyWith({
    Header? header,
    Body? body,
    Footer? footer,
    Configurations? configurations,
  }) =>
      PaywallModel(
        header: header ?? this.header,
        body: body ?? this.body,
        footer: footer ?? this.footer,
        configurations: configurations ?? this.configurations,
      );

  factory PaywallModel.fromJson(Map<String, dynamic> json) => _\$PaywallModelFromJson(json);

  Map<String, dynamic> toJson() => _\$PaywallModelToJson(this);

  List<String?> get products {
    List<String?> totalProducts = [];
    if (body?.products != null) {
      totalProducts = body!.products!.map((e) => e.productId).toList();
    }
    if (body?.buttons != null) {
      totalProducts.addAll(body!.buttons!.map((e) => e.product).toList());
    }

    return totalProducts;
  }

  List<String> get replacers => [
        "{PRICE}",
        "{WEEKLY_PRICE}",
        "{MONTHLY_PRICE}",
        "{YEARLY_PRICE}",
      ];
  void setProductPrices(Map<String, String> prices, {Map<String, String> freeDays = const {}}) {
    body?.buttons?.forEach((element) {
      log("Setting Product Button Prices to : \${element.text}}");

      if (element.text == null || element.product == null) {
        return;
      }

      final String price = prices[element.product] ?? '';

      for (var replace in replacers) {
        final String replacedText = element.text!.replaceAll(replace, price);
        element.text = replacedText;
      }

      log("Setting Product Button Prices to : \${element.text}}");
    });

    body?.products?.forEach((element) {
      log("Setting Product Prices to : \${element.title}}");

      if (element.title == null || element.productId == null) {
        return;
      }

      final String price = prices[element.productId] ?? '';

      for (var replace in replacers) {
        final String replacedTitle = element.title!.replaceAll(replace, price);
        element.title = replacedTitle;
      }
      if (element.description != null) {
        for (var replace in replacers) {
          final String replacedDesc = element.description!.replaceAll(replace, price);
          element.description = replacedDesc;
        }
      }

      log("Setting Product Prices to : \${element.title}}");
    });
  }
}

final examplePaywall = {
  "header": {
    "media": {"url": "IMAGE_URL", "type": "image"}
  },
  "body": {
    "content": {
      "title": {"text": "TITLE"},
      "description": {"text": "DESCRIPTION"}
    },
    "products": [
      {
        "title": "3-Days Free Trial",
        "description": "then {MONTHLY_PRICE} per month, cancel anytime",
        "productId": "com.example.app.monthly1",
        "hasToggle": true
      },
      {
        "title": "{YEARLY_PRICE} per year",
        "productId": "com.example.app.yearly1",
      }
    ],
    "backgroundColor": "#FFFFFF"
  },
  "footer": {
    "links": [
      {"name": "Privacy Policy", "url": "PRIVACY_POLICY_URL"},
      {"name": "Cancel anytime", "url": "TERMS_OF_SERVICE_URL"},
      {"name": "Restore"}
    ]
  },
  "configurations": {
    "closeButtonTiming": 4,
  }
};
""";