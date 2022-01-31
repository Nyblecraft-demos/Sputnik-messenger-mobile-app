import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/brand_theme.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/forms/profile/profile.dart';
import 'package:sputnik/ui/components/brand_alert.dart';
import 'package:sputnik/ui/components/brand_back_button/brand_back_button.dart';
import 'package:sputnik/ui/components/brand_button/brand_button.dart';
import 'package:sputnik/ui/components/brand_inputs/brand_inputs.dart';
import 'package:sputnik/ui/components/image_picker.dart';
import 'package:sputnik/ui/helpers/unfocus/unfocus.dart';
import 'package:sputnik/ui/route_transitions/basic.dart';
import 'package:sputnik/ui/screens/user_pofile/text_input_formatter.dart';
import 'package:sputnik/utils/help_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool canPop = canPopHelper(context);
    var theme = context.watch<BrandTheme>();
    return BlocProvider(
      create: (_) => ProfileFormCubit(authCubit: context.read<AuthenticationCubit>()),
      child: Builder(
        builder: (context) {
          var form = context.watch<ProfileFormCubit>();
          return BlocListener<ProfileFormCubit, FormCubitState>(
            listener: (context, state) {
              if (state.isSubmitted) {
                if (canPop) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: UnfocusOnTap(
              child: Scaffold(
                backgroundColor: theme.colorTheme.editProfileBackground,
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)?.editProfile ?? ''),
                  leading: BrandBackButton(),
                  elevation: 0,
                ),
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  minimum:
                      EdgeInsets.only(top: 16, bottom: 24, left: 24, right: 24),
                  child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _userHeader(context, form, theme)),
                        //_UserInfo(context, form),
                        //_Divider
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            child: BrandButton.blue(
                              text: AppLocalizations.of(context)?.save ?? '',
                              onPressed: () => form.trySubmit(),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userHeader(
      BuildContext context, ProfileFormCubit form, BrandTheme theme) {
    double textFieldHeight = 48;
    return SingleChildScrollView(
      child: Container(
        color: theme.colorTheme.editProfileBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<FieldCubit, FieldCubitState>(
              bloc: form.avatar,
              builder: (context, state) => avatarWidget(theme, context, state, form, width: 100, height: 100),
            ),
            SizedBox(height: 16),
            Container(
                decoration: BoxDecoration(
                    color: theme.colorTheme.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(13)),
                child: Column(
                  children: [
                    BrandInputs.withLabel(
                        fieldCubit: form.name,
                        formatter: UpperCaseTextFormatter(),
                        label: AppLocalizations.of(context)?.name ?? '',
                        height: textFieldHeight,
                        theme: theme),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                          height: 0.5, color: CupertinoColors.systemGrey4),
                    ),
                    BrandInputs.withLabel(
                        fieldCubit: form.surname,
                        formatter: UpperCaseTextFormatter(),
                        label: AppLocalizations.of(context)?.surname ?? '',
                        height: textFieldHeight,
                        theme: theme),
                  ],
                )),
            SizedBox(height: 16),
            Container(
                decoration: BoxDecoration(
                    color: theme.colorTheme.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(13)),
                child: Column(
                  children: [
                    BrandInputs.withLabel(
                        fieldCubit: form.nickname,
                        label: AppLocalizations.of(context)?.nickname ?? '',
                        height: textFieldHeight,
                        theme: theme),
                  ],
                )),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: theme.colorTheme.inputBackgroundColor,
                  borderRadius: BorderRadius.circular(13)),
              child: BrandInputs.withLabel(
                  lines: 2,
                  fieldCubit: form.bio,
                  label: AppLocalizations.of(context)?.biography ?? '',
                  height: textFieldHeight * 2,
                  theme: theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _Divider =>
      Divider(height: 0.5, indent: 0, endIndent: 0, color: BrandColors.grey3);

  Widget _UserInfo(BuildContext context, ProfileFormCubit form) =>
      BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
        final user = (state as WithUser).user;
        debugPrint(
            'edit profile:  user info = $user mobile = ${user.phoneNumberFormatted}');

        List<Widget> listItems = [
          // _Tile(
          //   title: 'Телефон',
          //   value: user.phoneNumberFormatted ?? '',
          //   onTap: () => {},
          // ),
          // _Tile(
          //   title: 'E-mail',
          //   value: user.email ?? '',
          //   onTap: () => Navigator.of(context).push(materialRoute(
          //       _EditProfileInfo(
          //           title: 'E-mail',
          //           cubit: form.email,
          //           placeholder: 'Электронная почта"',
          //           description: 'Люди могут поделиться этой ссылкой с другими людьми, чтобы найти ваш канал.',
          //           form: form
          //       )
          //   )),
          // ),
          _Tile(
            title: 'Никнейм',
            value: user.nickname,
            onTap: () => Navigator.of(context).push(materialRoute(_EditProfileInfo(
                title: 'Никнейм',
                cubit: form.nickname,
                placeholder: 'Никнейм',
                description:
                    'Люди могут поделиться этой ссылкой с другими людьми, чтобы найти ваш канал.',
                form: form))),
          ),
          // _Tile(
          //   title: 'Биография',
          //   value: user.bio ?? '',
          //   onTap: () => {},
          // )
        ];
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listItems.length,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          separatorBuilder: (context, index) => _Divider,
          itemBuilder: (context, index) => listItems[index],
        );
      });

  Widget avatarWidget(
      BrandTheme theme, BuildContext context, FieldCubitState state, ProfileFormCubit form,
      {double width = 100, double height = 100}) {
    debugPrint('avatar widget:  image = ${state.value}');
//    bool hasUrl = true;
//     final avatar = getIt.get<ChatService>().currentUser.avatar;
    final avatar = form.avatar.state.value;
    bool hasUrl = !(avatar == '' || avatar == null || avatar == 'null');
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomStart,
      children: [
        hasUrl
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: CupertinoColors.quaternarySystemFill,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: Image.network(avatar).image, fit: BoxFit.cover),
                ),
              )
            : Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: CupertinoColors.quaternarySystemFill,
                    shape: BoxShape.circle),
                child: Center(
                    child: Icon(Icons.person,
                        color: CupertinoColors.secondaryLabel,
                        size: width / 2.618)),
              ),
        GestureDetector(
          onTap: () => ImagePicker.show(context, form, ImageType.avatar),
          child: Container(
            decoration:
                BoxDecoration(color: theme.colorTheme.inputBackgroundColor, shape: BoxShape.circle),
            height: 32,
            width: 32,
            child: Icon(Icons.edit),
          ),
        ),
        Positioned(
          top: 0,
          right: -5,
          child: GestureDetector(
              onTap: () => BrandAlert.show(
                  context: context,
                  title: AppLocalizations.of(context)?.deletreAvatar ?? '',
                  subtitle: '',
                  secondaryButtonTitle: AppLocalizations.of(context)?.cancel,
                  secondaryButtonAction: () { Navigator.pop(context); },
                  mainButtonTitle: 'Ok',
                  mainButtonAction: () { _deleteAvatar(form, context); }),
              child: Container(
                decoration:
                BoxDecoration(color: theme.colorTheme.inputBackgroundColor, shape: BoxShape.circle),
                height: 32,
                width: 32,
                child: Icon(Icons.close),
              ),
            ))
      ],
    );
  }

  void _deleteAvatar(ProfileFormCubit form, BuildContext context) {
    debugPrint('deleteAvatar: initialValue = ${form.avatar.state.initialValue}  value = ${form.avatar.state.value}\n');
    form.avatar.setValue(null);
    Navigator.pop(context);
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var isDark =
        false; //context.watch<AppSettingsCubit>().state.isDarkModeOn ?? true;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: null,
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 16),
        child: Container(
          height: 56,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF3C3C63).withOpacity(0.6))),
                  SizedBox(width: 11),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: BrandColors
                        .grey3, //isDark ? BrandColors.white : BrandColors.grey3,
                    size: 15,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfileInfo extends StatelessWidget {
  const _EditProfileInfo(
      {Key? key,
      required this.title,
      required this.cubit,
      required this.placeholder,
      required this.description,
      required this.form})
      : super(key: key);

  final String title;
  final FieldCubit<String> cubit;
  final String placeholder;
  final String description;
  final ProfileFormCubit form;

  @override
  Widget build(BuildContext context) {
    return UnfocusOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: BrandBackButton(),
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          //top: false,
          minimum: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFF3F5F8),
                            borderRadius: BorderRadius.circular(13)),
                        child: Column(
                          children: [
                            BrandInputs.withLabel(
                              fieldCubit: cubit,
                              label: 'Имя',
                              height: 48,
                              //backgroundColor: Color(0xFFF3F5F8)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ],
                  ),
                ),
                BrandButton.blue(
                  text: 'Сохранить',
                  onPressed: () => form.trySubmit(),
                ),
              ]),
        ),
      ),
    );
  }
}

/*
class EditUserProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bool canPop = canPopHelper(context);
    double textFieldHieght = 48;
    return BlocProvider(
      create: (_) => ProfileFormCubit(authCubit: context.read<AuthenticationCubit>()),
      child: Builder(
        builder: (context) {
          var form = context.watch<ProfileFormCubit>();
          return BlocListener<ProfileFormCubit, FormCubitState>(
            listener: (context, state) {
              if (state.isSubmitted) {
                if (canPop) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: UnfocusOnTap(
              child: Scaffold(
                  appBar: canPop
                      ? AppBar(
                    title: Text('Редактировать профайл'),
                    leading: BrandBackButton(),
                    elevation: 0,
                  )
                      : null,
                  backgroundColor: CupertinoColors.systemGrey6,
                  resizeToAvoidBottomInset: true,
                  body: SafeArea(
                    top: false,
                    minimum: EdgeInsets.symmetric(vertical: 36),
                    child: SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: Column(
                        //mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 36, bottom: 16),
                              child: BlocBuilder<FieldCubit, FieldCubitState>(
                                bloc: form.avatar,
                                builder: (context, state) => avatarWidget(context, state, form, width: 150, height: 150),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              child: Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
                                  child: Column(
                                    children: [
                                      BrandInputs.withLabel(fieldCubit: form.name, label: 'Имя', height: textFieldHieght, backgroundColor: Colors.white),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Container(height: 0.5, color: CupertinoColors.systemGrey4),
                                      ),
                                      BrandInputs.withLabel(fieldCubit: form.surname, label: 'Фамилия (опционально)', height: textFieldHieght, backgroundColor: Colors.white),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 24, right: 24, bottom: 36),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13)
                                  ),
                                  child: Column(
                                    children: [
                                      BrandInputs.withLabel(
                                          fieldCubit: form.email,
                                          label: 'Электронная почта (опционально)',
                                          height: textFieldHieght,
                                          backgroundColor: Colors.white
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        child: Container(height: 0.5, color: CupertinoColors.systemGrey4),
                                      ),
                                      BrandInputs.withLabel(
                                          fieldCubit: form.nickname,
                                          label: 'Никнейм (опционально)',
                                          height: textFieldHieght,
                                          backgroundColor: Colors.white
                                      ),
                                    ],
                                  )
                              ),
                            ),

                          ]
                      ),
                    ),
                  ),
                  bottomNavigationBar: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                      child: BrandButton.blue(
                        text: 'Сохранить',
                        onPressed: () => form.trySubmit(),
                      ),
                    ),
                  ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget avatarWidget(BuildContext context, FieldCubitState state, ProfileFormCubit form, {double width = 100, double height = 100}) {
    debugPrint('avatar widget:  image = ${state.value}');
//    bool hasUrl = true;
    final avatar = getIt.get<ChatService>().currentUser.avatar;
    bool hasUrl = !(avatar == '' || avatar == null || avatar == 'null');
    print(form.avatar.state.value);
    return GestureDetector(
      onTap: () => ImagePicker.show(context, form),
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: CupertinoColors.quaternarySystemFill,
            shape: BoxShape.circle,
            image: hasUrl ? DecorationImage(image: Image.network(avatar).image, fit: BoxFit.cover) : null,
          ),
          child: !hasUrl
              ? Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: CupertinoColors.quaternarySystemFill,
                //borderRadius: BorderRadius.circular(50),
                shape: BoxShape.circle),
            child: Center(child: Icon(CupertinoIcons.person_solid, color: CupertinoColors.secondaryLabel, size: width / 2.618)),
          )
              : null),
    );
  }
}
 */
