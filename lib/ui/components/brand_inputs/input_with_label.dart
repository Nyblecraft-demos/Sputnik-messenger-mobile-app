part of 'brand_inputs.dart';

class InputWithLabel extends StatelessWidget {
  InputWithLabel(
      {Key? key,
      required this.fieldCubit,
      this.label,
      this.height,
      this.theme,
      this.lines,
      this.formatter})
      : super(key: key);

  final FieldCubit<String> fieldCubit;
  final String? label;
  final double? height;
  final BrandTheme? theme;
  final int? lines;
  final TextInputFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    final decorationBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.transparent, width: 0),
    );
    final textStyle = TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: theme?.colorTheme.highlightedText);
    return SizedBox(
      height: height ?? 57,
      child: CubitFormTextField(
        maxLines: lines ?? 1,
        formFieldCubit: fieldCubit,
        inputFormatters: formatter != null ? [formatter!] : null,
        //textAlign: TextAlign.center,
        style: textStyle,
        //scrollPadding: EdgeInsets.only(bottom: 70),
        decoration: InputDecoration(
          //filled: true,
          //fillColor: backgroundColor ?? CupertinoColors.systemGrey6,
          enabledBorder: decorationBorder,
          focusedBorder: decorationBorder,
          errorBorder: decorationBorder,
          focusedErrorBorder: decorationBorder,
          hintText: label,
          hintStyle: textStyle.copyWith(color: theme?.colorTheme.hintText),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}
