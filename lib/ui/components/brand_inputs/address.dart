part of 'brand_inputs.dart';

class _Address extends StatefulWidget {
  _Address({
    Key? key,
    required this.fieldCubit,
    this.hintText,
  }) : super(key: key);

  final FieldCubit<String> fieldCubit;
  final String? hintText;

  @override
  __AddressState createState() => __AddressState();
}

class __AddressState extends State<_Address> {
  FocusNode focusNode = FocusNode();
  String? hintText;
  @override
  void initState() {
    super.initState();
    hintText = widget.hintText;
    focusNode.addListener(() {
      if (focusNode.hasFocus && hintText != null) {
        setState(() {
          hintText = null;
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
    BrandTheme brandTheme = context.watch<BrandTheme>();
    return CubitFormTextField(
      focusNode: focusNode,
      formFieldCubit: widget.fieldCubit,
      style: brandTheme.textField1,
      textAlign: TextAlign.start,
      scrollPadding: EdgeInsets.only(bottom: 70),
      decoration: InputDecoration(
        filled: true,
        fillColor: brandTheme.colorTheme.backgroundColor1,
        hintText: hintText,
        hintStyle: brandTheme.textField1,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.transparent, width: 0),

        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.transparent, width: 0),

        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
