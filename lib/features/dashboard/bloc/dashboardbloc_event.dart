part of 'dashboardbloc_bloc.dart';

@immutable
sealed class DashboardblocEvent {}

class DashboardInitialFetchEvent extends DashboardblocEvent {}

class DashboardDepositEvent extends DashboardblocEvent {
  final TransactionModel transactionModel;

  DashboardDepositEvent({required this.transactionModel});
}

class DashboardWithdrawEvent extends DashboardblocEvent {
  final TransactionModel transactionModel;

  DashboardWithdrawEvent({required this.transactionModel});
}