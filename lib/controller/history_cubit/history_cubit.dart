import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part './history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  Map<String, dynamic> _selectedSort = {
    'title': 'Recent',
    'icon': Icons.history_toggle_off,
  };
  Map<String, dynamic> get selectedSort => _selectedSort;

  List<Map<String, dynamic>> sortItems = [
    {
      'title': 'Recent',
      'icon': Icons.history_toggle_off,
    },
    {
      'title': 'Upvoted',
      'icon': Icons.arrow_upward_outlined,
    },
    {
      'title': 'Downvoted',
      'icon': Icons.arrow_downward_sharp,
    },
    {
      'title': 'Hidden',
      'icon': Icons.visibility_off,
    },
  ];

  void choseSort(BuildContext context, Map<String, dynamic> item) {
    _selectedSort = item;
    Navigator.pop(context);
    emit(ChoseCurrentSort());
  }
}
