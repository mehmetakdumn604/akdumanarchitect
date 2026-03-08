/// Template for the generated example home view model.
const homeViewModel = """
import 'package:flutter/material.dart';
import '../../../core/base/viewModel/base_view_model.dart';
import '../../../core/mixins/show_bar.dart';
import '../model/post_model.dart';

class HomeViewModel extends ChangeNotifier with BaseViewModel, ShowBar {
  List<PostModel> posts = <PostModel>[];
  int page = 1;
  bool completed = false;

  Future<void> get() async {}
}

""";
