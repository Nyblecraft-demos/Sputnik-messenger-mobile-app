import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';

class TabItem {
  TabItem({
    required this.tab,
    required this.page
  });

  final BaseTab tab;
  final Widget page;
}

class BaseTabBar extends StatelessWidget implements PreferredSizeWidget {
  BaseTabBar({
    Key? key,
    required this.tabs,
    this.onTap,
  }) : super(key: key);

  final List<Widget> tabs;
  final void Function(int)? onTap;

  @override
  final Size preferredSize = Size.fromHeight(57);

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<BrandTheme>();
    return Container(
      color: theme.colorTheme.scaffoldBackground,
      height: 57,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: TabBar(
          labelColor: BrandColors.primary,
          unselectedLabelColor: theme.colorTheme.grayText,
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelPadding: EdgeInsets.symmetric(horizontal: 32),
          indicatorWeight: 2,
          indicatorColor: BrandColors.primary,
          automaticIndicatorColorAdjustment: false,
          isScrollable: true,
          tabs: tabs,
          onTap: onTap,
        ),
      ),
    );
  }

}


class BaseTab extends StatelessWidget {
  BaseTab({
    //required this.color,
    this.height = 57,
    required this.text
  });

  //final Color color;
  final double height;
  final String text;

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        height: height,
        child: Center(
          child: Text(text, softWrap: false, overflow: TextOverflow.fade),
          widthFactor: 1.0,
        ),
      );
}