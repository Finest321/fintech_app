import 'package:flutter_bloc/flutter_bloc.dart';
import '/models/transaction.dart';
import '/cubits/wallet_cubit.dart';

class TransactionState {
  final List<Transaction> transactions;

  TransactionState({required this.transactions});

  TransactionState copyWith({List<Transaction>? transactions}) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
    );
  }
}

class TransactionCubit extends Cubit<TransactionState> {
  final WalletCubit walletCubit;

  TransactionCubit(this.walletCubit) : super(TransactionState(transactions: []));

  void addTransaction({
    required String type,
    required double amount,
    required String accountName,
    required String accountNumber,
    required String bankName,
  }) {
    final newTx = Transaction(
      type: type,
      amount: amount,
      accountName: accountName,
      accountNumber: accountNumber,
      bankName: bankName,
      date: DateTime.now(),
      balance: walletCubit.state.balance, // ✅ capture balance after transaction
    );

    final updatedList = List<Transaction>.from(state.transactions)..add(newTx);
    emit(state.copyWith(transactions: updatedList));
  }
}
