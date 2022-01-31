import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik/logic/forms/sign_in/phone_input_formatter/country_code_data.dart';

part 'phone_formatter_helpers.dart';

class PhoneInputFormatter extends TextInputFormatter {
  final ValueChanged<PhoneCountryData?>? onCountrySelected;
  final bool allowEndlessPhone;

  PhoneCountryData? _countryData;
  String _lastValue = '';

  /// [onCountrySelected] when you enter a phone
  /// and a country is detected
  /// this callback gets called
  /// [allowEndlessPhone] if true, a phone can
  /// still be enterng after the whole mask is matched.
  /// use if you are not sure that all masks are supported
  PhoneInputFormatter({
    this.onCountrySelected,
    this.allowEndlessPhone = false,
  });

  String get masked => _lastValue;

  String get unmasked => '+${toNumericString(_lastValue, allowHyphen: false)}';

  bool get isFilled => isPhoneValid(masked);

  String mask(String value) {
    return formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: value),
    ).text;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var isErasing = newValue.text.length < oldValue.text.length;
    _lastValue = newValue.text;

    var onlyNumbers = toNumericString(newValue.text);
    String maskedValue;
    if (isErasing) {
      if (newValue.text.isEmpty) {
        _clearCountry();
      }
    }
    if (onlyNumbers.length == 2) {
      /// хак специально для России, со вводом номера с восьмерки
      /// меняем ее на 7
      var isRussianWrongNumber =
          onlyNumbers[0] == '8' && onlyNumbers[1] == '9' ||
              onlyNumbers[0] == '8' && onlyNumbers[1] == '3';
      if (isRussianWrongNumber) {
        onlyNumbers = '7${onlyNumbers[1]}';
        _countryData = null;
        _applyMask(
          '7',
          allowEndlessPhone,
        );
      }
    }

    maskedValue = _applyMask(onlyNumbers, allowEndlessPhone);
    if (maskedValue == oldValue.text && onlyNumbers != '7') {
      _lastValue = maskedValue;
      if (isErasing) {
        var newSelection = oldValue.selection;
        newSelection = newSelection.copyWith(
          baseOffset: oldValue.selection.baseOffset,
          extentOffset: oldValue.selection.baseOffset,
        );
        return oldValue.copyWith(
          selection: newSelection,
        );
      }
      return oldValue;
    }

    final endOffset = newValue.text.length - newValue.selection.end;
    final selectionEnd = maskedValue.length - endOffset;

    _lastValue = maskedValue;
    return TextEditingValue(
      selection: TextSelection.collapsed(offset: selectionEnd),
      text: maskedValue,
    );
  }

  Future _clearCountry() async {
    await Future.delayed(Duration(milliseconds: 5));
    _updateCountryData(null);
  }

  void _updateCountryData(PhoneCountryData? countryData) {
    _countryData = countryData;
    if (onCountrySelected != null) {
      onCountrySelected!(_countryData);
    }
  }

  String _applyMask(String numericString, bool allowEndlessPhone) {
    if (numericString.isEmpty) {
      _updateCountryData(null);
    } else {
      var countryData = PhoneCodes.getCountryDataByPhone(numericString);
      if (countryData != null) {
        _updateCountryData(countryData);
      }
    }
    if (_countryData != null) {
      return _formatByMask(
        numericString,
        _countryData!.phoneMask!,
        _countryData!.altMasks,
        0,
        allowEndlessPhone,
      );
    }
    return _formatByMask(
      numericString,
      '+00000000000000000',
      [],
      0,
      allowEndlessPhone,
    );
  }
}

class PhoneCountryData {
  final String? country;
  final String? phoneCode;
  final String? countryCode;
  final String? phoneMask;
  final List<String>? altMasks;

  PhoneCountryData._init({
    this.country,
    this.countryCode,
    this.phoneMask,
    this.altMasks,
    this.phoneCode,
  });

  String phoneCodeToString() {
    return '+$phoneCode';
  }

  factory PhoneCountryData.fromMap(Map value) {
    final countryData = PhoneCountryData._init(
      country: value['country'],
      phoneCode: value['phoneCode'] ?? value['internalPhoneCode'],
      countryCode: value['countryCode'],
      phoneMask: value['phoneMask'],
      altMasks: value['altMasks'],
    );
    return countryData;
  }

  @override
  String toString() {
    return '[PhoneCountryData(country: $country,' +
        ' phoneCode: $phoneCode, countryCode: $countryCode)]';
  }
}

class PhoneCodes {
  static PhoneCountryData? getCountryDataByPhone(
      String phone, {
        int? subscringLength,
      }) {
    if (phone.isEmpty) return null;
    subscringLength = subscringLength ?? phone.length;

    if (subscringLength < 1) return null;
    var phoneCode = phone.substring(0, subscringLength);

    var rawData = CountryCode.data().firstWhereOrNull(
          (data) => toNumericString(data!['internalPhoneCode']) == phoneCode,
    );
    if (rawData != null) {
      return PhoneCountryData.fromMap(rawData);
    }
    return getCountryDataByPhone(phone, subscringLength: subscringLength - 1);
  }

  static List<PhoneCountryData> getAllCountryDatasByPhoneCode(
      String phoneCode,
      ) {
    var list = <PhoneCountryData>[];
    CountryCode.data().forEach((data) {
      var c = toNumericString(data!['internalPhoneCode']);
      if (c == phoneCode) {
        list.add(PhoneCountryData.fromMap(data));
      }
    });
    return list;
  }
}