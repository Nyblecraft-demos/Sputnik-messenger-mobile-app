import 'package:intl/intl.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final formatter = DateFormat.Hm();

String timeToString(DateTime time) => formatter.format(time.toLocal());

String? timeAgo(DateTime? time) {
  final locale = AppLocalizations.of(getIt.get<NavigationService>().navigatorKey.currentContext!)?.localeName;
  if (locale == 'ru') {
    timeago.setLocaleMessages('ru', RuShort());
  }
  return time != null ? timeago.format(time.toLocal(), locale: locale) : null;
}

class RuShort implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => 'через';
  @override
  String suffixAgo() => 'назад';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'мин.';
  @override
  String aboutAMinute(int minutes) => 'мин.';
  @override
  String minutes(int minutes) => '$minutes ${_convert(minutes, 'minutes')}';
  @override
  String aboutAnHour(int minutes) => 'ч.';
  @override
  String hours(int hours) => '$hours ${_convert(hours, 'hours')}';
  @override
  String aDay(int hours) => 'день';
  @override
  String days(int days) => '$days ${_convert(days, 'days')}';
  @override
  String aboutAMonth(int days) => 'месяц';
  @override
  String months(int months) => '$months ${_convert(months, 'months')}';
  @override
  String aboutAYear(int year) => 'год';
  @override
  String years(int years) => '$years ${_convert(years, 'years')}';
  @override
  String wordSeparator() => ' ';
}

String _convert(int number, String type) {
  var mod = number % 10;
  var modH = number % 100;

  if (mod == 1 && modH != 11) {
    switch (type) {
      case 'minutes':
        return 'мин.';
      case 'hours':
        return 'ч.';
      case 'days':
        return 'д.';
      case 'months':
        return 'месяц';
      case 'years':
        return 'год';
      default:
        return '';
    }
  } else if (<int>[2, 3, 4].contains(mod) &&
      !<int>[12, 13, 14].contains(modH)) {
    switch (type) {
      case 'minutes':
        return 'мин.';
      case 'hours':
        return 'ч.';
      case 'days':
        return 'д.';
      case 'months':
        return 'месяца';
      case 'years':
        return 'года';
      default:
        return '';
    }
  }
  switch (type) {
    case 'minutes':
      return 'мин.';
    case 'hours':
      return 'ч.';
    case 'days':
      return 'д.';
    case 'months':
      return 'месяцев';
    case 'years':
      return 'лет';
    default:
      return '';
  }
}
