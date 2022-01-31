part of 'sign_in.dart';

class _PageOne extends StatelessWidget {
  const _PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BrandTheme textTheme = context.watch<BrandTheme>();
    return BlocProvider<SignInStepOneForm>(
      create: (_) => SignInStepOneForm(context.read<SignInCubit>()),
      child: Builder(
        builder: (context) {
          var form = context.watch<SignInStepOneForm>();
          var state = form.signInCubit.state;
          return Padding(
            padding: paddingV24H0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)?.enter ?? '',
                  style: textTheme.h1.copyWith(fontSize: 28),
                ),
                SizedBox(height: 19),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 238),
                  child: Text(
                    AppLocalizations.of(context)?.toSignIn ?? '',
                    style: textTheme.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40),
                BrandInputs.big(
                  fieldCubit: form.phoneNumber,
                  mask: '',
                  hintText: '+_ (___) ___-__-__',
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  child: BrandButton.blue(
                    progressIndicator: state is SignInProgress ? true : false,
                    isCapitalized: true,
                    text: AppLocalizations.of(context)?.proceed ?? '',
                    onPressed: state is SignInProgress ? null : form.trySubmit,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BrandStep(
                        text: AppLocalizations.of(context)?.step1 ?? '',
                        isActive: true),
                    SizedBox(width: 20),
                    BrandStep(
                        text: AppLocalizations.of(context)?.step2 ?? '',
                        isActive: false),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}