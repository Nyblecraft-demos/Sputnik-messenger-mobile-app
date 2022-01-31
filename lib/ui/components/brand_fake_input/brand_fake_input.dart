import 'package:flutter/cupertino.dart';
import 'package:sputnik/config/brand_theme.dart';

class BrandFakeInput extends StatelessWidget {
  const BrandFakeInput({
    Key? key,
    required this.string,
  }) : super(key: key);

  final String string;
  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();

    return Container(
      decoration: BoxDecoration(
        color: brandTheme.colorTheme.backgroundColor1,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: paddingV27H30,
      child: Text(
        string,
        style: brandTheme.textField1,
      ),
    );
  }
}
