import 'package:flutter/material.dart';

class TransparentCard extends StatelessWidget {
  const TransparentCard({
    Key? key,
    required this.child,
    required this.color
  }) : super(key: key);

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    //var isDark = context.watch<AppSettingsCubit>().state.isDarkModeOn ?? true;

    return Container(
      /*
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
              color: BrandColors.grey3,//isDark ? BrandColors.grey1 : BrandColors.grey3,
              width: 0.5),
        ),
      ),
       */
      color: color,
      alignment: Alignment.center,
      height: 62,
      child: child,
    );
  }
}
