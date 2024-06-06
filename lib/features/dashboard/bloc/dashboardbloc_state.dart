part of 'dashboardbloc_bloc.dart';

@immutable
sealed class DashboardblocState {}

final class DashboardblocInitial extends DashboardblocState {}

final class DashboardLoadingState extends DashboardblocState {}

final class DashboardErrorState extends DashboardblocState {}

final class DashboardSuccessState extends DashboardblocState {
  final List<TransactionModel> transactions;
  final int balance;

  DashboardSuccessState({required this.transactions, required this.balance});
}
