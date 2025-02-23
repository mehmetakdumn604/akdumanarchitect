import 'package:json_annotation/json_annotation.dart';
import 'link.dart';
part 'footer.g.dart';

@JsonSerializable()
class Footer {
    @JsonKey(name: "links")
    final List<Link>? links;

    Footer({
        this.links,
    });

    Footer copyWith({
        List<Link>? links,
    }) => 
        Footer(
            links: links ?? this.links,
        );

    factory Footer.fromJson(Map<String, dynamic> json) => _$FooterFromJson(json);

    Map<String, dynamic> toJson() => _$FooterToJson(this);
}
