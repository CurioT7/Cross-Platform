import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  int _currentPage = 0;
  int get currentPage => _currentPage;

  void changeCurrentPage(int page) {
    _currentPage = page;
    emit(ChangeCurrentPage());
  }
}
