import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';

class BlueCircle extends StatelessWidget {
  BlueCircle(
      this.icon,
      { Key? key,
        this.onTap,
        this.size,
        this.color
      }) : super(key: key);

  final IconData icon;
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    var cirle = Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color, //color != null ? color : BrandColors.blue1,
      ),
      child: Icon(
        icon,
        color: BrandColors.white,
        size: size,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cirle,
      );
    }
    return cirle;
  }
}
