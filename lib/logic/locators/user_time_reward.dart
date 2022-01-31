import 'dart:async';

import 'package:sputnik/logic/api/awards.dart';

class UserRewardInterval {
  Timer? fetchData;
  SpendingTimeReward? spendingTimeRewardData;
  bool needToReload = false;

  void _restartInterval() {
    const duration = Duration(minutes:30);
    if (fetchData != null) {
      fetchData?.cancel();
    }
    fetchData = new Timer(duration, () {needToReload = true;});
  }

  Future<SpendingTimeReward> getFata() async {
    if (spendingTimeRewardData != null && !needToReload) {
      return spendingTimeRewardData!;
    } else {
      _restartInterval();
      spendingTimeRewardData =  await UserReward().fetch();
      needToReload = false;
      return spendingTimeRewardData!;
    }
  }
}
