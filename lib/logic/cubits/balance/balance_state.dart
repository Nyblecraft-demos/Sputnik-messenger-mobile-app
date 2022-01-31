part of 'balance_cubit.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

class BalanceLoading extends BalanceState {}

class BalanceError extends BalanceState {
  BalanceError(this.exception);
  final Exception exception;
}

class BalanceLoaded extends BalanceState {
  BalanceLoaded(this.balance);

  final num balance;

  @override
  List<Object> get props => [balance];
}
