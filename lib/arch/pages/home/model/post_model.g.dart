/// Template for the generated JSON serialization logic for the post model.
const postModelG = """
part of 'post_model.dart';

PostModel _\$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      userId: json['userId'] as int?,
      id: json['id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _\$PostModelToJson(PostModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };
    """;
