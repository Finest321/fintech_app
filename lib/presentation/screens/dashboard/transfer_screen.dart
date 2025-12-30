import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '/cubits/wallet_cubit.dart';
import '/cubits/transaction_cubit.dart';
import 'confirm_transfer_screen.dart';

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedBankCode;
  String? _accountName;
  List<Map<String, String>> banks = [];

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  /// Fetch list of banks from Paystack (Test Mode)
  Future<void> _fetchBanks() async {
    final response = await http.get(
      Uri.parse("https://api.paystack.co/bank"),
      headers: {
        "Authorization":
        "Bearer sk_test_7178c42d2500ce6f7ee262a48d3b164710fbbc18"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        banks = (data['data'] as List)
            .map((bank) => {
          "name": bank['name'] as String,
          "code": bank['code'] as String,
        })
            .toList();
      });
    }
  }

  /// Resolve account name using Paystack (Test Mode)
  Future<void> _resolveAccount() async {
    if (_accountController.text.length == 10 && _selectedBankCode != null) {
      final response = await http.get(
        Uri.parse(
            "https://api.paystack.co/bank/resolve?account_number=${_accountController.text}&bank_code=$_selectedBankCode"),
        headers: {
          "Authorization":
          "Bearer sk_test_7178c42d2500ce6f7ee262a48d3b164710fbbc18"
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        setState(() {
          _accountName = data['data']['account_name'];
        });
      } else {
        setState(() {
          _accountName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Unable to resolve account")),
        );
      }
    }
  }

  void _goToConfirmation() {
    final amount = double.tryParse(_amountController.text) ?? 0;

    // ✅ Error handling checks
    if (_accountController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account number must be 10 digits")),
      );
      return;
    }

    if (_selectedBankCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a bank")),
      );
      return;
    }

    if (_accountName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please resolve account before transfer")),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid transfer amount")),
      );
      return;
    }

    // ✅ Check balance from WalletCubit
    final walletBalance = context.read<WalletCubit>().state.balance;
    if (amount > walletBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Insufficient balance")),
      );
      return;
    }

    // ✅ Proceed to confirmation screen
    final bankName =
    banks.firstWhere((bank) => bank['code'] == _selectedBankCode)['name']!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmTransferScreen(
          accountName: _accountName!,
          accountNumber: _accountController.text,
          bankName: bankName,
          amount: amount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final walletBalance = context.read<WalletCubit>().state.balance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Transfer"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // ✅ Show current balance
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Wallet Balance:",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text("₦${walletBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor)),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Account Number
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Account Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) {
                if (_accountController.text.length == 10) {
                  _resolveAccount();
                }
              },
            ),
            SizedBox(height: 20),

            // Bank Dropdown
            DropdownButtonFormField<String>(
              value: _selectedBankCode,
              isExpanded: true,
              items: banks
                  .map((bank) => DropdownMenuItem(
                value: bank['code'],
                child: Text(bank['name']!,
                    overflow: TextOverflow.ellipsis),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBankCode = value;
                });
                if (_accountController.text.length == 10) {
                  _resolveAccount();
                }
              },
              decoration: InputDecoration(
                labelText: "Select Bank",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Account Name Display
            if (_accountName != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("Account Name: $_accountName",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            SizedBox(height: 20),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Transfer Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _goToConfirmation,
                child: Text(
                  "Transfer",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
