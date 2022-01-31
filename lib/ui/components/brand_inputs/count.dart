part of 'brand_inputs.dart';

class _Count extends StatefulWidget {
  _Count({
    Key? key,
    required this.fieldCubit,
  }) : super(key: key);

  final FieldCubit<num> fieldCubit;

  @override
  __CountState createState() => __CountState();
}

class __CountState extends State<_Count> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    return CubitFormTextField1(
      focusNode: focusNode,
      formFieldCubit: widget.fieldCubit,
      style: brandTheme.bigNumbers,
      textAlign: TextAlign.start,
      scrollPadding: EdgeInsets.only(bottom: 70),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        filled: true,
        fillColor: brandTheme.colorTheme.backgroundColor1,
        //suffix: ,
        //border: InputBorder.none,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.transparent, width: 0),

        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.transparent, width: 0),

        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }
}

class CubitFormTextField1 extends StatefulWidget {
  const CubitFormTextField1({
    required this.formFieldCubit,
    this.keyboardType,
    this.decoration,
    this.obscureText = false,
    this.inputFormatters,
    this.scrollPadding,
    this.style,
    this.textAlign,
    this.focusNode,
    this.cursorColor,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  final FieldCubit<num> formFieldCubit;
  final InputDecoration? decoration;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? scrollPadding;
  final TextStyle? style;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final int? maxLines;

  @override
  CubitFormTextFieldState createState() => CubitFormTextFieldState();
}

class CubitFormTextFieldState extends State<CubitFormTextField1> {
  TextEditingController controller = TextEditingController();
  late StreamSubscription subscription;

  @override
  void initState() {
    controller = TextEditingController(
        text: widget.formFieldCubit.state.value.toString())
      ..addListener(() {
        widget.formFieldCubit
            .setValue(_checkValue(controller.text));
      });
    subscription = widget.formFieldCubit.stream.listen(_cubitListener);
    super.initState();
  }

  void _cubitListener(FieldCubitState<num> state) {
    if (state is InitialFieldCubitState) {
      controller.clear();
      controller.text = state.value.toString();
      _unfocus();
    }
    if (state is ExternalChangeFieldCubitState) {
      _unfocus();

      controller.text = state.value.toString();
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  void _unfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  num _checkValue(String text) {
    if (text.isEmpty) { return 0; }
    if (text.length == 2 && text.contains('0.')) { return 0; }
    if (text.startsWith('.') && text.length == 1) { return 0; }
    return num.parse(text);

  }

  @override
  void dispose() {
    subscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldCubit, FieldCubitState>(
        bloc: widget.formFieldCubit,
        builder: (context, state) {
          return TextField(
            maxLines: widget.maxLines,
            cursorColor: widget.cursorColor,
            focusNode: widget.focusNode,
            onChanged: (value) {
              var selection = controller.selection;
              final RegExp regexp = new RegExp(r'^0+(?=.)');
              var match = regexp.firstMatch(value);

              var matchLengh = match?.group(0)?.length ?? 0;
              if (matchLengh != 0) {
                controller.text = value.replaceAll(regexp, '');
                controller.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: min(matchLengh, selection.extent.offset),
                  ),
                );
              }
            },
            textAlign: widget.textAlign ?? TextAlign.left,
            style: widget.style ?? Theme.of(context).textTheme.subtitle1,
            keyboardType: widget.keyboardType,
            controller: controller,
            obscureText: widget.obscureText,
            decoration: widget.decoration,
            inputFormatters: widget.inputFormatters,
            scrollPadding: widget.scrollPadding ?? EdgeInsets.all(20.0),
          );
        });
  }
}
