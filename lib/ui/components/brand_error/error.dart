import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BrandError extends StatelessWidget {
  const BrandError({
    Key? key,
    required this.error,
    required this.stackTrace,
  }) : super(key: key);

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(error.toString()),
                Text('stackTrace: '),
                Text(stackTrace.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
