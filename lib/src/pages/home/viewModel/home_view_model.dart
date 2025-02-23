import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/base/viewModel/base_view_model.dart';
import '../../../core/exports/constants_exports.dart';
import '../../../core/mixins/show_bar.dart';
import '../model/post_model.dart';

class HomeViewModel extends ChangeNotifier with BaseViewModel, ShowBar {
  List<PostModel> posts = <PostModel>[];
  int page = 1;
  bool completed = false;

  Future<void> get() async {
    var res = await networkService!.send<PostModel, List<PostModel>>(
      EndPointConstants.posts,
      type: HttpTypes.get,
      parseModel: PostModel(),
    );
    if (res is List<PostModel>) {
      posts = res;
      notifyListeners();
    }
  }

  // sunucuya fotoğraf göndereceğimiz zaman örnek isteğimiz bu şekilde
  Future<void> uploadFileRequestExample() async {
    await networkService!.send(
      EndPointConstants.posts,
      type: HttpTypes.patch,
      contentType: Headers.multipartFormDataContentType,
      data: FormData.fromMap({
        'photo': await MultipartFile.fromFile('path'),
      }),
      parseModel: null,
    );
  }
}
