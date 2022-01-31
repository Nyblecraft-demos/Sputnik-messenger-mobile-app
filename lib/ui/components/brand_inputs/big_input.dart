part of 'brand_inputs.dart';


class BigInput extends StatefulWidget {
  BigInput({
    Key? key,
    required this.fieldCubit,
    required this.mask,
    this.hintText,
    this.textAlign ,
  }) : super(key: key);

  final FieldCubit<String> fieldCubit;
  final String mask;
  final String? hintText;
  final TextAlign? textAlign;
  @override
  _BigInputState createState() => _BigInputState();
}

class _BigInputState extends State<BigInput> {
  FocusNode focusNode = FocusNode();
  String? hintText;
  @override
  void initState() {
    super.initState();
    hintText = widget.hintText;
    focusNode.addListener(() {
      if (focusNode.hasFocus && hintText != null) {
        setState(() {
          hintText = '+\u2800';
        });
      } else if (!focusNode.hasFocus && hintText == null) {
        setState(() {
          hintText = widget.hintText;
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //BrandTheme brandTheme = context.watch<BrandTheme>();
    final decorationBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.transparent, width: 0),

    );
    final textStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: CupertinoColors.label,
        //height: 1.5
    );

    return widget.mask.isEmpty ?
      CubitFormTextField(
        formFieldCubit: widget.fieldCubit,
        focusNode: focusNode,
        inputFormatters: [PhoneInputFormatter(allowEndlessPhone: true)],
        style: textStyle,
        textAlign: widget.textAlign,
        keyboardType: TextInputType.number,
        scrollPadding: EdgeInsets.only(bottom: 70),
        decoration: InputDecoration(
          filled: true,
          fillColor: CupertinoColors.systemGrey6,
          hintText: hintText,
          hintStyle: textStyle.copyWith(color: !focusNode.hasFocus ? CupertinoColors.quaternaryLabel : CupertinoColors.label),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          enabledBorder: decorationBorder,
          focusedBorder: decorationBorder,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 26),
        ),
    )
    : CubitFormMaskedTextField(
      formFieldCubit: widget.fieldCubit,
      focusNode: focusNode,
      mask: widget.mask,
      style: textStyle,
      textAlign: widget.textAlign,
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.only(bottom: 70),
      decoration: InputDecoration(
        filled: true,
        fillColor: CupertinoColors.systemGrey6,
        hintText: !focusNode.hasFocus ? hintText : '',
        hintStyle: textStyle.copyWith(color: CupertinoColors.quaternaryLabel),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: decorationBorder,
        focusedBorder: decorationBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
    );
  }
}
