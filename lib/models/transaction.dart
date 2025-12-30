class Transaction {
  final String type;
  final double amount;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final DateTime date;
  final double balance; // ✅ new field

  Transaction({
    required this.type,
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.date,
    required this.balance,
  });
}
