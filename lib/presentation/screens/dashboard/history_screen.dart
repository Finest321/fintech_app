import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/transaction_cubit.dart';
import '/models/transaction.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionCubit>().state.transactions;

    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: transactions.isEmpty
          ? Center(child: Text("No transactions yet"))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (_, index) {
          final tx = transactions[index];

          final formattedDate =
              "${tx.date.day}/${_monthAbbrev(tx.date.month)}/${tx.date.year}";
          final formattedTime =
              "${tx.date.hour.toString().padLeft(2, '0')}:${tx.date.minute.toString().padLeft(2, '0')}";

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                tx.type == "Deposit"
                    ? Icons.arrow_downward
                    : Icons.swap_horiz,
                color: tx.type == "Deposit" ? Colors.green : Colors.blue,
              ),
              title: Text(
                "₦${tx.amount.toStringAsFixed(2)} – ${tx.type}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Account Name: ${tx.accountName}"),
                  Text("Account No.: ${tx.accountNumber}"),
                  Text("Bank: ${tx.bankName}"),
                  Text("Date: $formattedDate  $formattedTime"),
                  Text("Balance : ₦${tx.balance.toStringAsFixed(2)}"), // ✅ new line
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthAbbrev(int month) {
    const months = [
      "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.",
      "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."
    ];
    return months[month - 1];
  }
}
