import 'dart:developer';

import 'package:curio/models/account_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/ahmed_api.dart';

part './account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  AccountInfo? accountInfo;

  void getUserInfo() async {
    try {
      emit(GetAccountInfoLoadingState());
      accountInfo = await ApiService().getAccountInfo();
      emit(GetAccountInfoSuccessState());
    } catch (e) {
      log(e.toString());
      emit(GetAccountInfoErrorState());
    }
  }
}
