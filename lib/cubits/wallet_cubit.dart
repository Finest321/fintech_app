import 'package:flutter_bloc/flutter_bloc.dart';

class WalletState {
  final double balance;
  WalletState(this.balance);
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState(0));

  void deposit(double amount) {
    emit(WalletState(state.balance + amount));
  }

  void transfer(double amount) {
    emit(WalletState(state.balance - amount));
  }

  // 👇 Add this method
  void withdraw(double amount) {
    emit(WalletState(state.balance - amount));
  }
}
