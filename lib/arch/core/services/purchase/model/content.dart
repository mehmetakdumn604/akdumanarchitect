var contentModel = """import 'package:json_annotation/json_annotation.dart';
import 'description.dart';
import 'period.dart';
part 'content.g.dart';

@JsonSerializable()
class Content {
    @JsonKey(name: "title")
    final Description? title;
    @JsonKey(name: "description")
    final Description? description;
    @JsonKey(name: "freeTrial")
    final Description? freeTrial;
    @JsonKey(name: "period")
    final Period? period;

    Content({
        this.title,
        this.description,
        this.freeTrial,
        this.period,
    });

    Content copyWith({
        Description? title,
        Description? description,
        Description? freeTrial,
        Period? period,
    }) => 
        Content(
            title: title ?? this.title,
            description: description ?? this.description,
            freeTrial: freeTrial ?? this.freeTrial,
            period: period ?? this.period,
        );

    factory Content.fromJson(Map<String, dynamic> json) => _\$ContentFromJson(json);

    Map<String, dynamic> toJson() => _\$ContentToJson(this);
}
""";