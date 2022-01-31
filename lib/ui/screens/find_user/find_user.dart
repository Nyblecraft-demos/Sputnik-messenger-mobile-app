import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/forms/send_form/send_form.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_contact_tiles/brand_contact_tiles.dart';
import 'package:sputnik/ui/helpers/unfocus/unfocus.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'by_phone.dart';
part 'by_name.dart';

class FindUserPage extends StatefulWidget {
  const FindUserPage({Key? key}) : super(key: key);

  @override
  _FindUserPageState createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {
        _selectedSegment = controller.index;
      });
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
          title: Text(AppLocalizations.of(context)?.addContact ?? ''),
          leading: BrandBackButton(),
        ),
        body: Scaffold(
          appBar: segmentedControl(context),
          body: TabBarView(
            controller: controller,
            children: [
              _ByName(),
              _ByPhone(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget segmentedControl(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(82),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: CupertinoSlidingSegmentedControl<int>(
            children: <int, Widget>{
              0: Text(
                AppLocalizations.of(context)?.account ?? '',
                style: context.watch<BrandTheme>().tabButton.copyWith(
                    color: _selectedSegment == 0 ? Colors.white : null),
                textAlign: TextAlign.center,
              ),
              1: Text(
                AppLocalizations.of(context)?.phoneNumber ?? '',
                style: context.watch<BrandTheme>().tabButton.copyWith(
                    color: _selectedSegment == 1 ? Colors.white : null),
                textAlign: TextAlign.center,
              ),
            },
            onValueChanged: (index) {
              setState(() {
                _selectedSegment = index ?? 0;
                controller.animateTo(_selectedSegment);
              });
            },
            groupValue: _selectedSegment,
            thumbColor: BrandColors.primary,
          ),
        ),
      );

  /*
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? BrandColors.grey1
        : BrandColors.grey3;

    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Добавить контакт'),
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
                      text: 'По учетной записи',
                    ),
                  ),
                  Expanded(
                    child: TabButton(
                      onPress: () => controller.animateTo(1),
                      isActive: controller.index == 1,
                      text: 'По номеру телефона',
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
              _ByName(),
              _ByPhone(),
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
        child: Text(text, style: textStyle),
      ),
    );
  }
}
