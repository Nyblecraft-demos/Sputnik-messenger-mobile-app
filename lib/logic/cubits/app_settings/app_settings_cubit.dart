import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:sputnik/config/hive_config.dart';
export 'package:provider/provider.dart';

part 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    bool? isDarkModeOn,
    bool? isModuleWalletOn,
    bool? isNotificationsOn,
    bool? isFlaggedMessagesOn,
    String? locale,
    String? background
  }) : super(AppSettingsState(
      isDarkModeOn: isDarkModeOn,
      isModuleWalletOn: isModuleWalletOn,
      isNotificationsOn: isNotificationsOn,
      isFlaggedMessagesOn: isFlaggedMessagesOn,
      locale: locale,
      background: background
  ));

  Box box = Hive.box(BNames.appSettings);
  bool? isDarkModeOn;
  bool? isModuleWalletOn;
  bool? isNotificationsOn;
  bool? isFlaggedMessagesOn;
  String? locale;
  String? background;

  void load() {
    isDarkModeOn = box.get(BNames.isDarkModeOn);
    isModuleWalletOn = box.get(BNames.isModuleWalletOn);
    isNotificationsOn = box.get(BNames.isNotificationsOn) ?? true;
    isFlaggedMessagesOn = box.get(BNames.isFlaggedMessagesOn);
    locale = box.get(BNames.locale);
    background = box.get(BNames.background);

    if (isModuleWalletOn != null) {
      emit(state.copyWith(isDarkModeOn: isDarkModeOn, isModuleWalletOn: isModuleWalletOn, isNotificationsOn: isNotificationsOn, isFlaggedMessagesOn: isFlaggedMessagesOn, locale: locale, background: background));
    } else {
      isModuleWalletOn = false;
      box.put(BNames.isModuleWalletOn, isModuleWalletOn);
      emit(state.copyWith(isDarkModeOn: isDarkModeOn, isModuleWalletOn: isModuleWalletOn, isNotificationsOn: isNotificationsOn, isFlaggedMessagesOn: isFlaggedMessagesOn, locale: locale, background: background));
    }

    debugPrint('settings: load:  isDarkModeOn = ${state.isDarkModeOn}  isModuleWalletOn = ${state.isModuleWalletOn} isNotificationsOn = ${state.isNotificationsOn} isFlaggedMessagesOn = ${state.isFlaggedMessagesOn} locale = ${state.locale} background = ${state.background}');
  }

  void update({bool? isDarkModeOn, bool? isModuleWalletOn, bool? isNotificationsOn, bool? isFlaggedMessagesOn, String? locale, String? background}) {
    debugPrint('settings: update in:  isDarkModeOn = $isDarkModeOn  isModuleWalletOn = $isModuleWalletOn isNotificationsOn = $isNotificationsOn isFlaggedMessagesOn = $isFlaggedMessagesOn locale = ${state.locale} background = ${state.background}');
    if (isDarkModeOn != null) {
      box.put(BNames.isDarkModeOn, isDarkModeOn);
      this.isDarkModeOn = isDarkModeOn;
    }
    if (isModuleWalletOn != null) {
      box.put(BNames.isModuleWalletOn, isModuleWalletOn);
      this.isModuleWalletOn = isModuleWalletOn;
    }
    if (isNotificationsOn != null) {
      box.put(BNames.isNotificationsOn, isNotificationsOn);
      this.isNotificationsOn = isNotificationsOn;
    }
    if (isFlaggedMessagesOn != null) {
      box.put(BNames.isFlaggedMessagesOn, isFlaggedMessagesOn);
      this.isFlaggedMessagesOn = isFlaggedMessagesOn;
    }
    if (locale != null) {
      box.put(BNames.locale, locale);
      this.locale = locale;
    }
    if (background != null) {
      box.put(BNames.background, background);
      this.background = background;
    }
    emit(state.copyWith(isDarkModeOn: this.isDarkModeOn, isModuleWalletOn: this.isModuleWalletOn, isNotificationsOn: this.isNotificationsOn, isFlaggedMessagesOn: this.isFlaggedMessagesOn, locale: this.locale, background: this.background));
    debugPrint('settings: load:  isDarkModeOn = ${state.isDarkModeOn}  isModuleWalletOn = ${state.isModuleWalletOn} isNotificationsOn = ${state.isNotificationsOn} isFlaggedMessagesOn = ${state.isFlaggedMessagesOn} locale = ${state.locale} background = ${state.background}');
  }

  void updateDarkModeState(bool? isDarkModeOn) {
    if (isDarkModeOn != null) {
      this.isDarkModeOn = isDarkModeOn;
      emit(state.copyWith(isDarkModeOn: isDarkModeOn, isModuleWalletOn: isModuleWalletOn, isNotificationsOn: isNotificationsOn, isFlaggedMessagesOn: isFlaggedMessagesOn, locale: locale, background: background));
      debugPrint('settings: emmit:  isDarkModeOn = ${state.isDarkModeOn}  isModuleWalletOn = ${state.isModuleWalletOn} isNotificationsOn = ${state.isNotificationsOn} isFlaggedMessagesOn = ${state.isFlaggedMessagesOn} locale = ${state.locale} background = ${state.background}');
    }
  }
}
