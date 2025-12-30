import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final double amount;
  final String accountName;
  final String accountNumber;
  final String bankName;

  SuccessScreen({
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final now = DateTime.now();

    // Format date & time as 30/Dec./2025 13:30
    final formattedDate =
        "${now.day}/${_monthAbbrev(now.month)}/${now.year}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Transfer Successful"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),

            Text(
              "Transfer Successful!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            Text(
              "You have successfully transferred ₦${amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // ✅ Transaction details card
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
                  _buildDetailRow("Date", "$formattedDate  $formattedTime"),
                ],
              ),
            ),
            SizedBox(height: 40),

            // ✅ Back to Home button with visible text
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Colors.white, // ✅ ensures visibility
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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

  String _monthAbbrev(int month) {
    const months = [
      "Jan.", "Feb.", "Mar.", "Apr.", "May.", "Jun.",
      "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."
    ];
    return months[month - 1];
  }
}
