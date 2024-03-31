part of './account_cubit.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class GetAccountInfoLoadingState extends AccountState {}

class GetAccountInfoSuccessState extends AccountState {}

class GetAccountInfoErrorState extends AccountState {}
