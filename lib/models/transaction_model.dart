class TransactionModel {
  final String user;
  final int amount;
  final String reason;
  final DateTime time;

  TransactionModel({
    required this.user,
    required this.amount,
    required this.reason,
    required this.time,
  });
}