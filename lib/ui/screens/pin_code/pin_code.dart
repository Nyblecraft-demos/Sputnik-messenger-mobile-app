import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/brand_colors.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/api/modules.dart';
import 'package:sputnik/logic/api/wallet.dart';
import 'package:sputnik/logic/cubits/app_settings/app_settings_cubit.dart';
import 'package:sputnik/logic/cubits/authentication/authentication_cubit.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sputnik/ui/components/brand_snackBar.dart';

class PinCodePage extends StatefulWidget {
  PinCodePage({Key? key}) : super(key: key);

  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
//

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;
  String code = '';
  String savedPinCode = '';
  bool isPinCodeEqual = false;
  String? pinCodeFromPreferences = '';
  bool isLoading = false;
  bool pinExist = false;
  late AppSettingsCubit settings;

  @override
  void initState() {
    _checkPinExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    settings = context.watch<AppSettingsCubit>();
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topCenter,
              colors: [
                BrandColors.primary,
                BrandColors.primary,
//                Colors.purple[900]!.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    headerIcon(),
                    pinCodeee(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  pinCodeee() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 25,
        ),
        buildSecurityText(),
        SizedBox(
          height: 25,
        ),
        buildPinRow(),
        SizedBox(
          height: 40,
        ),
        buildNumPad(),
      ],
    );
  }

  buildSecurityText() {
    return Text(
      savedPinCode == '' ? (AppLocalizations.of(context)?.enterPin ?? '') : (AppLocalizations.of(context)?.confirmPin ?? ''),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 17,
      ),
    );
  }

  buildPinRow() {
    var width = MediaQuery.of(context).size.width;
    // var width;
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DigitHolder(width: width, index: 0, selectedIndex: selectedIndex, code: code),
          DigitHolder(width: width, index: 1, selectedIndex: selectedIndex, code: code),
          DigitHolder(width: width, index: 2, selectedIndex: selectedIndex, code: code),
          DigitHolder(width: width, index: 3, selectedIndex: selectedIndex, code: code),
        ],
      ),
    );
  }

  buildNumPad() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  number: "1",
                  onPressed: () {
                    addDigit(1);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "2",
                  onPressed: () {
                    addDigit(2);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "3",
                  onPressed: () {
                    addDigit(3);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  number: "4",
                  onPressed: () {
                    addDigit(4);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "5",
                  onPressed: () {
                    addDigit(5);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "6",
                  onPressed: () {
                    addDigit(6);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber(
                  number: "7",
                  onPressed: () {
                    addDigit(7);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "8",
                  onPressed: () {
                    addDigit(8);
                  },
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "9",
                  onPressed: () {
                    addDigit(9);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KeyboardNumber1(
                  number: "0",
                ),
                SizedBox(width: 25),
                KeyboardNumber(
                  number: "0",
                  onPressed: () {
                    addDigit(0);
                  },
                ),
                SizedBox(width: 37),
                IconButton(
                  onPressed: () {
                    backspace();
                  },
                  icon: Icon(
                    Icons.backspace,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  addDigit(int digit) async {
    if (savedPinCode != '') {
      if (code.length != 4) {
        setState(() {
          code = code + digit.toString();
          selectedIndex = code.length;
        });
      }
      if (code.length == 4 && code != savedPinCode && !pinExist) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackBar(
              text: AppLocalizations.of(context)?.enteredWrongPin ?? '',
              durationMS: 300,
              error: true)
        );
      }
      if (code.length == 4 && code == savedPinCode && !pinExist) {
        _setPin(int.parse(code));
      }
    } else {
      setState(() {
        code = code + digit.toString();
        selectedIndex = code.length;
      });
      if (code.length == 4 && !pinExist) {
        Future.delayed(const Duration(milliseconds: 250), () {
          SnackBar snackBar = SnackBar(
            content: Text((AppLocalizations.of(context)?.confirmPin ?? '')),
            duration: Duration(milliseconds: 250),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            savedPinCode = code;
            code = '';
            selectedIndex = 0;
          });
        });
      }
      if (code.length == 4 && pinExist) {
        final isValid = await _validatePin(int.parse(code));
        if (isValid) {
          _turnWalletOn();
        } else {
          const delay = 300;
          ScaffoldMessenger.of(context).showSnackBar(
              snackBar(
                  text: AppLocalizations.of(context)?.enteredWrongPin ?? '',
                  durationMS: delay,
                  error: true)
          );
          Future.delayed(const Duration(milliseconds: delay), () {
            Navigator.pop(context);
          });
        }
      }
    }
  }

  void _turnWalletOn() async {
    var res = await ModulesApi().activateWalletModule(true);
    await _updateUser(res.data['data']['address']);
    settings.update(isModuleWalletOn: true);
    const delay = 300;
    ScaffoldMessenger.of(context).showSnackBar(
        snackBar(
            text: AppLocalizations.of(context)?.walletConnected ?? '',
            durationMS: delay,
            error: false)
    );
    Future.delayed(const Duration(milliseconds: delay), () {
      Navigator.pop(context);
    });
  }

  Future<void> _updateUser(String wallet) async {
    var authCubit = context.read<AuthenticationCubit>();
    var authCubitState = authCubit.state as WithUser;
    ChatService chatService = getIt.get<ChatService>();
    var newUser = authCubitState.user
        .setPhoneNumber(chatService.currentUser.phoneNumber ?? '')
        .setWallet(wallet)
        .setName(chatService.currentUser.name)
        .setSurname(chatService.currentUser.surname)
        .setNickname(chatService.currentUser.nickname)
        .setAvatar(chatService.currentUser.avatar ?? '');
    authCubit.update(user: newUser);
    _updateAuthModel(wallet);

  }

  void _updateAuthModel(String wallet) {
    Box userBox = Hive.box(BNames.authModel);
    AuthModel? authModel = userBox.get(BNames.authModel);
    final newAuthModel = AuthModel(
        token: authModel?.token ?? '',
        phoneNumber: authModel?.phoneNumber ?? '',
        address: wallet);
    userBox.put(BNames.authModel, newAuthModel);
  }

  backspace() {
    if (code.length == 0) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedIndex = code.length;
    });
  }

  void _setPin(int code) async {
    await WalletApi().setPinCode(code).then((response) {
     if (response.statusCode! >= 200) {
       _turnWalletOn();
     }
    });
  }

  void _checkPinExist() async {
    var res = await WalletApi().checkPinCodeExist();
    pinExist = res.data['data']["isCreated"];
  }


    Future<bool> _validatePin(int code) async {
    var res = await WalletApi().validatePinCode(code);
    return res.data['data']['isValid'];
  }

  Widget headerIcon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          child: Image.asset(
            'assets/images/title_logo.png',
            scale: 1.2,
            alignment: Alignment.center,
          ),
        ),
        Container(
          // width: 30,
          // child: Divider(
          //   color: Colors.white,
          //   thickness: 2,
          // ),
        ),
        SizedBox(
          height: 3,
        ),
//        Text(
//          'Sputnik',
//          style: TextStyle(
//            fontWeight: FontWeight.bold,
//            color: Colors.white,
//            fontSize: 20,
//            letterSpacing: 2,
//          ),
//        ),
      ],
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final String? number;
  final Function()? onPressed;

  const KeyboardNumber({Key? key, this.number, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 1.0),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              number!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 24 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardNumber1 extends StatelessWidget {
  final String? number;
  final Function()? onPressed;

  const KeyboardNumber1({Key? key, this.number, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, style: BorderStyle.solid, width: 1.0),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Center(
            child: Text(
              number!,
              style: TextStyle(
                color: Colors.transparent,
                fontWeight: FontWeight.w400,
                fontSize: 24 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigitHolder extends StatelessWidget {
  final int? selectedIndex;
  final int? index;
  final String? code;

  const DigitHolder({
    @required this.selectedIndex,
    Key? key,
    @required this.width,
    this.index,
    this.code,
  }) : super(key: key);

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: width! * 0.05,
      width: width! * 0.05,
      margin: EdgeInsets.only(right: 10, left: 10),
      decoration: BoxDecoration(
        color: Colors.white12,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: index == selectedIndex ? Colors.transparent : Colors.transparent,
            offset: Offset(0, 0),
            spreadRadius: 1.5,
            blurRadius: 2,
          )
        ],
      ),
      child: code!.length > index!
          ? PhysicalModel(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: 5,
              shadowColor: Colors.black,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 5,
                  //     blurRadius: 7,
                  //     offset: Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
                ),
              ),
            )
          : Container(),
    );
  }
}
