import 'package:example/src/core/exports/constants_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/base/view/base_view.dart';
import '../viewModel/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModel: HomeViewModel(),
      onPageBuilder: (context, model, child) {
        return Scaffold(
          appBar: buildAppBar(model, context),
          body: buildBody(model),
        );
      },
    );
  }

  Widget buildBody(HomeViewModel model) {
    return Center(
      child: Text(
        "Congratulations!. Structure is Ready. You can start to work",
        textAlign: TextAlign.center,
        style: TextStyleConstants.regularStyle(
            fontSize: 20.sp, color: ColorConstants.black),
      ),
    );
  }

  AppBar buildAppBar(HomeViewModel model, BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () async => await model.get(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
