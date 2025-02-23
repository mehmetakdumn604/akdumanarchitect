import 'package:json_annotation/json_annotation.dart';
part 'media.g.dart';

@JsonSerializable()
class Media {
  @JsonKey(name: "url")
  final String? url;
  @JsonKey(name: "type")
  final String? type;

  Media({
    this.url,
    this.type,
  });

  Media copyWith({
    String? url,
    String? type,
  }) =>
      Media(
        url: url ?? this.url,
        type: type ?? this.type,
      );

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
