part of './history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class ChoseCurrentSort extends HistoryState {}

class GetLoadingState extends HistoryState {}

class GetSuccessState extends HistoryState {}

class GetErrorState extends HistoryState {}

class GetHistoryState extends HistoryState {}
