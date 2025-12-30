import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/wallet_cubit.dart';
import '/cubits/transaction_cubit.dart';
import 'success_screen.dart';

class ConfirmTransferScreen extends StatelessWidget {
  final String accountName;
  final String accountNumber;
  final String bankName;
  final double amount;

  ConfirmTransferScreen({
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Transfer"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder text
            Text("Reminder",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Double check the transfer details before you proceed.\n"
                  "Please note that successful transfers cannot be reversed.",
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 30),

            // Transaction details card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Name", accountName),
                  _buildDetailRow("Account No.", accountNumber),
                  _buildDetailRow("Bank", bankName),
                  _buildDetailRow("Amount", "₦${amount.toStringAsFixed(2)}"),
                ],
              ),
            ),

            Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Recheck"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ Deduct balance
                      context.read<WalletCubit>().transfer(amount);

                      // ✅ Log transaction with full details
                      context.read<TransactionCubit>().addTransaction(
                        type: "Transfer",
                        amount: amount,
                        accountName: accountName,
                        accountNumber: accountNumber,
                        bankName: bankName,
                      );

                      // ✅ Navigate to SuccessScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuccessScreen(
                            amount: amount,
                            accountName: accountName,
                            accountNumber: accountNumber,
                            bankName: bankName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white, // ✅ ensures contrast
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label:",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: TextStyle(fontSize: 14, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
