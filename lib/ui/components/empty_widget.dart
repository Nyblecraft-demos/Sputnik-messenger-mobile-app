import 'package:flutter/cupertino.dart';
import 'package:sputnik/config/brand_theme.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.bubble_left_bubble_right,
          color: CupertinoColors.tertiaryLabel,
          size: 64,
        ),
        SizedBox(height: 24),
        Text(
          text,
          style: context.watch<BrandTheme>().h2.copyWith(color: CupertinoColors.tertiaryLabel),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
