import 'package:flutter/material.dart';

class UnfocusOnTap extends StatelessWidget {
  const UnfocusOnTap({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: child,
    );
  }
}
