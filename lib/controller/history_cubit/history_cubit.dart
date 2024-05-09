import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part './history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  List posts = [];

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
    getHistory();
  }

  void getHiddenPosts() async {
    try {
      emit(GetLoadingState());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/hidden'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          posts = responseBody['hiddenPosts'];
          emit(GetSuccessState());
        }
      } else {
        log(response.body.toString());
        emit(GetErrorState());
      }
    } catch (e) {
      log('Exception occurred: $e');
      emit(GetErrorState());
    }
  }

  void getRecentPosts() async {
    try {
      emit(GetLoadingState());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/getHistory'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody['success']) {
          posts = responseBody['recentPosts'];
          emit(GetSuccessState());
        }
      } else {
        log(response.body.toString());
        emit(GetErrorState());
      }
    } catch (e) {
      log('Exception occurred: $e');
      emit(GetErrorState());
    }
  }

  void getUpVotedPosts() async {
    try {
      emit(GetLoadingState());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/user/upvoted'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        posts = responseBody['votedPosts'];
        emit(GetSuccessState());
      } else {
        log(response.body.toString());
        emit(GetErrorState());
      }
    } catch (e) {
      log('Exception occurred: $e');
      emit(GetErrorState());
    }
  }

  void getDownVotedPosts() async {
    try {
      emit(GetLoadingState());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/user/downvoted'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        posts = responseBody['votedPosts'];
        emit(GetSuccessState());
      } else {
        log(response.body.toString());
        emit(GetErrorState());
      }
    } catch (e) {
      log('Exception occurred: $e');
      emit(GetErrorState());
    }
  }

  getHistory() {
    switch (_selectedSort['title']) {
      case 'Hidden':
        getHiddenPosts();
        break;
      case 'Recent':
        getRecentPosts();
        break;
      case 'Upvoted':
        getUpVotedPosts();
        break;
      case 'Downvoted':
        getDownVotedPosts();
        break;
      default:
        posts = [];
        emit(GetHistoryState());
    }
  }
}
