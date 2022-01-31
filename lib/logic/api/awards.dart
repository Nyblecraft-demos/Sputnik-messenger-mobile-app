import 'dart:async';

import 'package:either_option/either_option.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sputnik/config/get_it_config.dart';
import 'package:sputnik/config/hive_config.dart';
import 'package:sputnik/logic/locators/navigation.dart';
import 'package:sputnik/logic/model/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'api.dart';

class UserReward extends SputnikPublicApi {
  Box userBox = Hive.box(BNames.authModel);

  AuthModel? get authModel => userBox.get(BNames.authModel);
  String? get token => authModel?.token;

  Future<SpendingTimeReward> fetch() async {
    var client = await getClient();
    var res = await client.get('/coins/award',
        options: Options(headers: {'Authorization': token}));
    client.close();
    final data = res.data['data'];
    //debugPrint('Awards:  fetch:  data / ${data.runtimeType} = $data  activeTime / ${data['activeTime'].runtimeType} = ${data['activeTime']}');
    final model = SpendingTimeReward.fromJson(data as Map<String, dynamic>);
    //debugPrint('Awards:  fetch:  model = $model');
    return model;
  }

  Future<Either<Exception, SpendingTimeReward>> withdraw(
      {required double amount}) async {
    var client = await getClient();
    var res;
    try {
      res = await client.post('/coins/withdraw',
          data: {'amount': amount},
          options: Options(headers: {'Authorization': token}));
    } catch (error) {
      debugPrint('Awards: withdraw error: $error');
      return Left(Exception('withdraw error'));
    }
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      final data = res.data['data'];
      return Right(SpendingTimeReward.fromJson(data as Map<String, dynamic>));
    } else if (res.statusCode == HttpStatus.badRequest) {
      return Left(Exception('withdraw error'));
    }
    throw 'withdraw error';
  }

  Future<List<TransactionsData>?> withdrawHistory() async {
    var client = await getClient();
    var res;
    try {
      res = await client.get('/coins/withdrawHistory',
          options: Options(headers: {'Authorization': token}));
    } catch (error) {
      debugPrint('Awards: withdraw history: $error');
      return null;
    }
    client.close();
    if (res.statusCode == HttpStatus.ok) {
      List<TransactionsData> listOfTransactions = [];
      final data = res.data['data'];
      data.forEach((element) {
        listOfTransactions.add(TransactionsData.fromJson(element));
      });
      return listOfTransactions;
    } else if (res.statusCode == HttpStatus.badRequest) {
      return null;
    }
    throw 'withdraw error';
  }
}

class SpendingTimeReward {
  SpendingTimeReward({
    required this.activeTime,
    required this.ouroEarned,
    required this.readyToWithdraw,
    required this.withdrawnAllTime,
    required this.minWithDrawAmount,
    required this.currentEarnRate,
  });

  int activeTime;
  double ouroEarned;
  double readyToWithdraw;
  double withdrawnAllTime;
  double minWithDrawAmount;
  final double currentEarnRate;
  final translation = AppLocalizations.of(
      getIt.get<NavigationService>().navigatorKey.currentContext!);
  DateTime startTime = DateTime.now();

  int get addSeconds => DateTime.now().difference(startTime).inSeconds;
  double get addOuro => addSeconds * currentEarnRate;

  double get totalReward => readyToWithdraw + addOuro;
  double get totalEarned => ouroEarned + addOuro;

  String activeString() {
    var total = activeTime + addSeconds;
    final yearsText = translation?.year;
    final _years = 60 * 60 * 24 * 365;
    final years = total ~/ _years;
    final y = years > 0 ? '$years$yearsText' : null;

    total -= years * _years;
    final daysText = translation?.day;
    final _days = 60 * 60 * 24;
    final days = total ~/ _days;
    final d = days > 0 ? '$days$daysText' : null;

    total -= days * _days;
    final hourText = translation?.hour;
    final _hours = 60 * 60;
    final hours = total ~/ _hours;
    final h = hours > 0 ? '$hours$hourText' : null;

    total -= hours * _hours;
    final minuteText = translation?.minute;
    final _minutes = 60;
    final minutes = total ~/ _minutes;
    final m = minutes > 0 ? '$minutes$minuteText' : null;

    final secondText = translation?.second;
    total -= minutes * _minutes;
    final s = total > 0 ? '$total$secondText' : null;
    final value = [y, d, h, m, s].where((e) => e != null).join('  ');

    return '${translation?.active}:  $value';
  }

  String get formattedEarned =>
      NumberFormat('###,###,##0.00').format(ouroEarned + addOuro);
  String get formattedReward =>
      NumberFormat('###,###,##0.00').format(readyToWithdraw + addOuro);
  String formattedEarnedKMB(String format) =>
      _k_m_b_generator(format, ouroEarned);
  String formattedRewardKMB(String format) =>
      _k_m_b_generator(format, readyToWithdraw + addOuro);
  String rewardString() => '+ $formattedReward';

  String _k_m_b_generator(String format, double num) {
    if (format == 'K') {
      return "${(num / 1000).toStringAsFixed(1)}K";
    }
    if (format == 'M') {
      return "${(num / 1000000).toStringAsFixed(1)}M";
    } else {
      return "${(num / 1000000000).toStringAsFixed(1)}B";
    }
  }

  Future<Either<Exception, SpendingTimeReward>> withdrawAllReward() async {
    var res = await UserReward().withdraw(amount: totalReward.floorToDouble());
    startTime = DateTime.now();
    return res;
  }

  factory SpendingTimeReward.fromJson(Map<String, dynamic> json) =>
      SpendingTimeReward(
        activeTime: json['activeTime'] as int,
        ouroEarned: json['ouroEarned'] as double,
        readyToWithdraw: json['readyToWithdraw'] as double,
        withdrawnAllTime: (json['withdrawnAllTime'] as num).toDouble(),
        minWithDrawAmount: json['minWithDrawAmount'] as double,
        currentEarnRate: json['currentEarnRate'] as double,
      );

  Map<String, dynamic> toJson() => {
        'activeTime': activeTime,
        'ouroEarned': ouroEarned,
        'readyToWithdraw': readyToWithdraw,
        'withdrawnAllTime': withdrawnAllTime,
        'minWithDrawAmount': minWithDrawAmount,
        'currentEarnRate': currentEarnRate
      };
}

class TransactionsData {
  TransactionsData({
    required this.slug,
    required this.amount,
    required this.address,
    required this.status,
    required this.date,
    this.explorerUrl,
  });

  String slug;
  double amount;
  String address;
  String status;
  DateTime date;
  String? explorerUrl;

  factory TransactionsData.fromJson(Map<String, dynamic> json) =>
      TransactionsData(
          slug: json['slug'] as String,
          amount: (json['amount'] as num).toDouble(),
          address: json['address'] as String,
          status: json['status'] as String,
          date: DateTime.parse(json['date'] as String).toLocal(),
          // date: DateFormat('''yyyy-MM-dd'T'HH:mm:ss.SSS''')
          //     .parse(json['date'] as String)
          //     .toLocal(),
          explorerUrl: json['explorerUrl'] as String?);
}
