import 'package:json_annotation/json_annotation.dart';

import 'media.dart';
part 'header.g.dart';


@JsonSerializable()
class Header {
    @JsonKey(name: "media")
    final Media? media;
    @JsonKey(name: "backgroundColor")
    final String? backgroundColor;

    Header({
        this.media,
        this.backgroundColor,
    });

    Header copyWith({
        Media? media,
        String? backgroundColor,
    }) => 
        Header(
            media: media ?? this.media,
            backgroundColor: backgroundColor ?? this.backgroundColor,
        );

    factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

    Map<String, dynamic> toJson() => _$HeaderToJson(this);
}
