import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/forms/send_form/send_form.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/helpers/unfocus/unfocus.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';

class OuroPage extends StatefulWidget {
  const OuroPage({
    Key? key,
    required this.walletAddress
  }) : super(key: key);

  final String walletAddress;

  @override
  _OuroPageState createState() => _OuroPageState();
}

class _OuroPageState extends State<OuroPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Color borderColor = Theme.of(context).brightness == Brightness.dark
    //     ? BrandColors.grey1
    //     : BrandColors.grey3;

    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Кошелёк Ouro'),
          leading: BrandBackButton(),
        ),
        body: OuroWalletPage(walletAddress: widget.walletAddress)
      ),
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? BrandColors.grey1
        : BrandColors.grey3;

    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Кошелёк Ouro'),
          leading: BrandBackButton(),
        ),
        body: Scaffold(
          appBar: PreferredSize(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TabButton(
                      onPress: () => controller.animateTo(0),
                      isActive: controller.index == 0,
                      text: 'Отправить',
                    ),
                  ),
                  Expanded(
                    child: TabButton(
                      onPress: () => controller.animateTo(1),
                      isActive: controller.index == 1,
                      text: 'Получить',
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60),
          ),
          body: TabBarView(
            controller: controller,
            children: [
              WalletSentTab(walletAddress: widget.walletAddress),
              WalletReceiveTab(),
            ],
          ),
        ),
      ),
    );
  }
   */
}

class TabButton extends StatelessWidget {
  const TabButton({
    Key? key,
    required this.onPress,
    required this.isActive,
    required this.text,
  }) : super(key: key);

  final VoidCallback onPress;
  final bool isActive;
  final String text;

  @override
  Widget build(BuildContext context) {
    BrandTheme brandTheme = context.watch<BrandTheme>();
    Color? background = isActive ? BrandColors.blue1 : null;
    TextStyle textStyle = brandTheme.tabButton
        .copyWith(color: isActive ? BrandColors.white : null);

    return InkWell(
      onTap: isActive ? null : onPress,
      child: Container(
        color: background,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
