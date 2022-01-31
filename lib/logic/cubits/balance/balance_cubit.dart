import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sputnik/logic/api/wallet.dart';
import 'package:sputnik/ui/screens/ouro/ouro_wallet.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(BalanceLoading());

  WalletApi api = WalletApi();

  void check(CryptoToken crypto) async {
    emit(BalanceLoading());
    var balance = await api.getBalance(crypto);

    var newState = balance.fold(
      (e) => BalanceError(e),
      (balance) => BalanceLoaded(balance),
    );
    emit(newState);
  }

  void reloadBalance(CryptoToken crypto) {
    check(crypto);
  }
}
