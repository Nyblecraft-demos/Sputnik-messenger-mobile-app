part of 'sign_in.dart';

class _PageTwo extends StatelessWidget {
  const _PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var accepted = false;
    BrandTheme textTheme = context.watch<BrandTheme>();
    var signInCubit = context.watch<SignInCubit>();
    return BlocProvider<SignInStepTwoForm>(
      create: (_) => SignInStepTwoForm(signInCubit),
      child: Builder(
        builder: (context) {
          var form = context.watch<SignInStepTwoForm>();
          var state = form.signInCubit.state;
          return BlocListener<SignInStepTwoForm, FormCubitState>(
            bloc: form,
            listener: (context, state) {
              if (state is SignPinCode) {
                Navigator.of(context).push(
                  materialRoute(
                    RootPage(),
                  ),
                );
              }
            },
            child: Padding(
              padding: paddingV24H0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)?.enterCode ?? '',
                    style: textTheme.h1.copyWith(fontSize: 28),
                  ),
                  SizedBox(height: 19),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Text(
                      AppLocalizations.of(context)?.codeSent ?? '',
                      style: textTheme.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: BrandInputs.big(
                          fieldCubit: form.codeNumber,
                          mask: '000-000',
                          hintText: '###-###',
                        ),
                      );
                    },
                  ),
                  _checkBox(accepted, state, form, textTheme),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BrandStep(
                        text: AppLocalizations.of(context)?.step1 ?? '',
                        isActive: false,
                        onTap: () => signInCubit.resetPhone(),
                      ),
                      SizedBox(width: 20),
                      BrandStep(text: AppLocalizations.of(context)?.step2 ?? '', isActive: true),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _checkBox(bool accepted, SignInState state, SignInStepTwoForm form, BrandTheme textTheme) {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    activeColor: BrandColors.primary,
                    value: accepted,
                    onChanged: (bool? value) {
                      setState(() {
                        accepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(child: _richText(context, textTheme.body))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 20),
              width: double.infinity,
              child: BrandButton.blue(
                progressIndicator: state is SignInProgress ? true : false,
                isCapitalized: true,
                text: AppLocalizations.of(context)?.signIn ?? '',
                onPressed: accepted ? (state is SignInProgress ? null : form.trySubmit) : null,
              ),
            ),
            SizedBox(height: 10,),

          ],
      );
    });
  }

  Widget _richText(BuildContext context, TextStyle textStyle) {
    return Column(
      children: [
        SizedBox(height: 10,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)?.checkboxPrivacyAndTerms1 ?? '',
                style: textStyle
              ),
              TextSpan(
                text: AppLocalizations.of(context)?.checkboxPrivacyAndTerms2 ?? '',
                style: textStyle.copyWith(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()..onTap = () => openUrl(AppLocalizations.of(context)?.localeName == 'ru' ? 'https://sputnik-1.com/ru/privacy/' : 'https://sputnik-1.com/privacy/')
              ),
              TextSpan(
                  text: AppLocalizations.of(context)?.and ?? '',
                  style: textStyle
              ),
              TextSpan(
                  text: AppLocalizations.of(context)?.checkboxPrivacyAndTerms3 ?? '',
                  style: textStyle.copyWith(color: Colors.blueAccent),
                  recognizer: TapGestureRecognizer()..onTap = () => openUrl(AppLocalizations.of(context)?.localeName == 'ru' ? 'https://sputnik-1.com/ru/conditions/' : 'https://sputnik-1.com/conditions/')
              ),
            ]
          )),
      ]
    );
  }
}
