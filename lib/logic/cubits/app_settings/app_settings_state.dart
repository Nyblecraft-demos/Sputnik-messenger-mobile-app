part of 'app_settings_cubit.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.isDarkModeOn,
    this.isModuleWalletOn,
    this.isNotificationsOn,
    this.isFlaggedMessagesOn,
    this.locale,
    this.background,
  });

  final bool? isDarkModeOn;
  final bool? isModuleWalletOn;
  final bool? isNotificationsOn;
  final bool? isFlaggedMessagesOn;
  final String? locale;
  final String? background;

  AppSettingsState copyWith({
    bool? isDarkModeOn,
    bool? isModuleWalletOn,
    bool? isNotificationsOn,
    bool? isFlaggedMessagesOn,
    String? locale,
    String? background,
  }) => AppSettingsState(
      isDarkModeOn: isDarkModeOn,// ?? this.isDarkModeOn,
      isModuleWalletOn: isModuleWalletOn,// ?? this.isModuleWalletOn
      isNotificationsOn: isNotificationsOn,
      isFlaggedMessagesOn: isFlaggedMessagesOn,
      locale: locale,
      background: background,
  );

  @override
  List<Object?> get props => [isDarkModeOn, isModuleWalletOn, isNotificationsOn, isFlaggedMessagesOn, locale, background];
}
