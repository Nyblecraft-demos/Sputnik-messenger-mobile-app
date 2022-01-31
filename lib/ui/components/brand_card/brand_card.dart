import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/ui/components/transparent_card/transparent_card.dart';

class BrandCard extends StatelessWidget {
  const BrandCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.onPress,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback? onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var isDark = false; //context.watch<AppSettingsCubit>().state.isDarkModeOn ?? true;

    return InkWell(
      onTap: onPress,
      onDoubleTap: null,
      child: TransparentCard(
        color: color,
        child: Row(
          children: [
            SizedBox(width: 16),
            //getIcon(isDark),
            //SizedBox(width: 15),
            Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(
              CupertinoIcons.chevron_right,
              color: BrandColors.grey3, //isDark ? BrandColors.white : BrandColors.grey3,
              size: 15,
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget getIcon(bool isDark) {
    return Container(
      height: 40,
      width: 40,
      child: Icon(icon, size: 20, color: BrandColors.primary),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: BrandColors.grey4,
      ),
    );
  }
}