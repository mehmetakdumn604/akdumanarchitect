import 'package:json_annotation/json_annotation.dart';
part 'button_style.g.dart';

@JsonSerializable()
class ButtonStyle {
    @JsonKey(name: "color")
    final String? color;
    @JsonKey(name: "backgroundColor")
    final String? backgroundColor;
    @JsonKey(name: "borderRadius")
    final int? borderRadius;

    ButtonStyle({
        this.color,
        this.backgroundColor,
        this.borderRadius,
    });

    ButtonStyle copyWith({
        String? color,
        String? backgroundColor,
        int? borderRadius,
    }) => 
        ButtonStyle(
            color: color ?? this.color,
            backgroundColor: backgroundColor ?? this.backgroundColor,
            borderRadius: borderRadius ?? this.borderRadius,
        );

    factory ButtonStyle.fromJson(Map<String, dynamic> json) => _$ButtonStyleFromJson(json);

    Map<String, dynamic> toJson() => _$ButtonStyleToJson(this);
}
