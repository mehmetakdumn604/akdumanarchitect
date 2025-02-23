import 'package:json_annotation/json_annotation.dart';
part 'link.g.dart';

@JsonSerializable()
class Link {
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "url")
    final String? url;

    Link({
        this.name,
        this.url,
    });

    Link copyWith({
        String? name,
        String? url,
    }) => 
        Link(
            name: name ?? this.name,
            url: url ?? this.url,
        );

    factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

    Map<String, dynamic> toJson() => _$LinkToJson(this);
}
