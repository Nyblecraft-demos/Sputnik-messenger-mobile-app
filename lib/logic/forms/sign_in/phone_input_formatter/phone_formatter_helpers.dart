part of 'phone_input_formatter.dart';

final RegExp _digitRegExp = RegExp(r'[-0-9]+');
final RegExp _positiveDigitRegExp = RegExp(r'[0-9]+');
final RegExp _digitWithPeriodRegExp = RegExp(r'[-0-9]+(\.[0-9]+)?');
final RegExp _oneDashRegExp = RegExp(r'[-]{2,}');
final RegExp _startPlusRegExp = RegExp(r'^\+{1}[)(\d]+');
final RegExp _maskContentsRegExp = RegExp(r'^[-0-9)( +]{3,}$');
final RegExp _isMaskSymbolRegExp = RegExp(r'^[-\+ )(]+$');

enum InvalidPhoneAction { ShowUnformatted, ReturnNull, ShowPhoneInvalidString }

String toNumericString(
    String? inputString, {
      bool allowPeriod = false,
      bool allowHyphen = true,
    }) {
  if (inputString == null) return '';
  var regexWithoutPeriod = allowHyphen ? _digitRegExp : _positiveDigitRegExp;
  var regExp = allowPeriod ? _digitWithPeriodRegExp : regexWithoutPeriod;
  return inputString.splitMapJoin(regExp,
      onMatch: (m) => m.group(0)!, onNonMatch: (nm) => '');
}

void checkMask(String mask) {
  if (_oneDashRegExp.hasMatch(mask)) {
    throw ('A mask cannot contain more than one dash (-) symbols in a row');
  }
  if (!_startPlusRegExp.hasMatch(mask)) {
    throw ('A mask must start with a + sign followed by a digit of a rounded brace');
  }
  if (!_maskContentsRegExp.hasMatch(mask)) {
    throw ('A mask can only contain digits, a plus sign, spaces and dashes');
  }
}

bool isUnmaskableSymbol(String? symbol) {
  if (symbol == null || symbol.length > 1) {
    return false;
  }
  return _isMaskSymbolRegExp.hasMatch(symbol);
}

bool isDigit(String? character) {
  if (character == null || character.isEmpty || character.length > 1) {
    return false;
  }
  return _digitRegExp.stringMatch(character) != null;
}

bool isPhoneValid(
    String phone, {
      bool allowEndlessPhone = false,
    }) {
  phone = toNumericString(
    phone,
    allowHyphen: false,
  );
  if (phone.isEmpty) {
    return false;
  }
  var countryData = PhoneCodes.getCountryDataByPhone(
    phone,
  );
  if (countryData == null) {
    return false;
  }
  var formatted = _formatByMask(
    phone,
    countryData.phoneMask!,
    countryData.altMasks,
    0,
    allowEndlessPhone,
  );
  var rpeprocessed = toNumericString(
    formatted,
    allowHyphen: false,
  );
  if (allowEndlessPhone) {
    var contains = phone.contains(rpeprocessed);
    return contains;
  }
  var correctLength = formatted.length == countryData.phoneMask!.length;
  if (correctLength != true && countryData.altMasks != null) {
    return countryData.altMasks!.any(
          (altMask) => formatted.length == altMask.length,
    );
  }
  return correctLength;
}

String? formatAsPhoneNumber(
    String phone, {
      InvalidPhoneAction invalidPhoneAction = InvalidPhoneAction.ShowUnformatted,
      bool allowEndlessPhone = false,
      String? defaultMask,
    }) {
  if (!isPhoneValid(
    phone,
    allowEndlessPhone: allowEndlessPhone,
  )) {
    switch (invalidPhoneAction) {
      case InvalidPhoneAction.ShowUnformatted:
        if (defaultMask == null) return phone;
        break;
      case InvalidPhoneAction.ReturnNull:
        return null;
      case InvalidPhoneAction.ShowPhoneInvalidString:
        return 'invalid phone';
    }
  }
  phone = toNumericString(phone);
  var countryData = PhoneCodes.getCountryDataByPhone(phone);

  if (countryData != null) {
    return _formatByMask(
      phone,
      countryData.phoneMask!,
      countryData.altMasks,
      0,
      allowEndlessPhone,
    );
  } else {
    return _formatByMask(
      phone,
      defaultMask!,
      null,
      0,
      allowEndlessPhone,
    );
  }
}

String _formatByMask(
    String text,
    String mask,
    List<String>? altMasks, [
      int altMaskIndex = 0,
      bool allowEndlessPhone = false,
    ]) {
  text = toNumericString(text, allowHyphen: false);
  var result = <String>[];
  var indexInText = 0;
  for (var i = 0; i < mask.length; i++) {
    if (indexInText >= text.length) {
      break;
    }
    var curMaskChar = mask[i];
    if (curMaskChar == '0') {
      var curChar = text[indexInText];
      if (isDigit(curChar)) {
        result.add(curChar);
        indexInText++;
      } else {
        break;
      }
    } else {
      result.add(curMaskChar);
    }
  }

  var actualDigitsInMask = toNumericString(
    mask,
    allowHyphen: false,
  ).replaceAll(',', '');
  if (actualDigitsInMask.length < text.length) {
    if (altMasks != null && altMaskIndex < altMasks.length) {
      var formatResult = _formatByMask(
        text,
        altMasks[altMaskIndex],
        altMasks,
        altMaskIndex + 1,
        allowEndlessPhone,
      );
      return formatResult;
    }

    if (allowEndlessPhone) {
      result.add(' ');
      for (var i = actualDigitsInMask.length; i < text.length; i++) {
        result.add(text[i]);
      }
    }
  }

  final jointResult = result.join();
  return jointResult;
}