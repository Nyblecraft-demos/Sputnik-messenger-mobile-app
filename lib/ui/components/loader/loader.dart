import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Container(
        width: double.infinity,
        child: Text(
          text,
          style: context.watch<BrandTheme>().h2.copyWith(
                color: BrandColors.grey3,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
