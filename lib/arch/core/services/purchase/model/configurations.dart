var configurationsModel= """import 'package:json_annotation/json_annotation.dart';
part 'configurations.g.dart';


@JsonSerializable()
class Configurations {
    @JsonKey(name: "closeButtonTiming")
    final int? closeButtonTiming;
    @JsonKey(name: "theme")
    final String? theme;
    @JsonKey(name: "declineButton")
    final bool? declineButton;

    Configurations({
        this.closeButtonTiming,
        this.theme,
        this.declineButton,
    });

    Configurations copyWith({
        int? closeButtonTiming,
        String? theme,
        bool? declineButton,
    }) => 
        Configurations(
            closeButtonTiming: closeButtonTiming ?? this.closeButtonTiming,
            theme: theme ?? this.theme,
            declineButton: declineButton ?? this.declineButton,
        );

    factory Configurations.fromJson(Map<String, dynamic> json) => _\$ConfigurationsFromJson(json);

    Map<String, dynamic> toJson() => _\$ConfigurationsToJson(this);
}
"""
;