import 'package:flutter/material.dart';
import 'package:flutter_common/res/string.dart';

class ErrorComponent extends StatelessWidget {

  final String text;
  final Function onClick;

  ErrorComponent({this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Text(text ?? AppStrings.tip_error),
      ),
      onTap: onClick,
    );
  }
}
