/// Template that adds extension getters for common SizedBox gaps.
const sizedBoxExtension = """
import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget showByCondition(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }
}
""";
