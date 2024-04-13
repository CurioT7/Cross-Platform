import 'dart:convert';
import 'dart:developer';

import 'package:curio/widgets/report_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/chose_reason_widget.dart';
import '../../widgets/report_problem_widget.dart';
import 'package:http/http.dart' as http;
part './report_state.dart';

enum ReportProfileType {
  username,
  displayName,
  profileImage,
  bannerImage,
  bio,
}

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());
  final String _baseUrl = 'http://20.19.89.1/api';
  String? _selectedReason;
  String? get selectedReason => _selectedReason;
  String? _text;
  String? get problemText => _text;
  int _currentPage = 1;
  int get currentPage => _currentPage;
  final TextEditingController controller = TextEditingController();
  ReportProfileType? _reportProfileType;
  ReportProfileType? get type => _reportProfileType;
  final List<String> items = [
    "Rule Break",
    "harassment",
    "threatening violence",
    "hate",
    "minor abuse or sexualization",
    "sharing personal information",
    "non-consensual intimate media",
    "prohibited transaction",
    "impersonation",
    "copyright violation",
    "trademark violation",
    "self-harm or suicide",
    "spam",
  ];

  void choseReason(String reason) {
    _selectedReason = reason;
    emit(ChoseReasonState());
  }

  void choseCurrentPage(int page) {
    _currentPage = page;
    emit(ChangeCurrentPageState());
  }

  void choseReportProfileType(ReportProfileType? type) {
    _reportProfileType = type;
    emit(ChangeReportProfileTypeState());
  }

  void getProblemText(String val) {
    _text = val;
    emit(GetProblemTextState());
  }

  Widget getCurrentPage(bool isUser) {
    if (isUser) {
      switch (_currentPage) {
        case 1:
          return const ReportUserWidget();
        case 2:
          return ChoseReasonWidget(items: items);
        case 3:
          return const ReportProblemWidget();
        default:
          return Container();
      }
    } else {
      switch (_currentPage) {
        case 1:
          return ChoseReasonWidget(items: items);
        case 2:
          return const ReportProblemWidget();
        default:
          return Container();
      }
    }
  }

  void reportProfile(String userName) async {
    try {
      emit(ReportLoadingState());
      late final String reportType;
      if (_reportProfileType == ReportProfileType.username) {
        reportType = 'username';
      } else {
        reportType = 'profile image';
      }
      final Uri url = Uri.parse('$_baseUrl/report_user');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";
      var res = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "reportedUsername": userName,
          "reportType": reportType,
          "reportReason": _selectedReason,
          "reportDetails": controller.text
        }),
      );
      choseCurrentPage(4);
      log(res.body);
      emit(ReportSuccessState());
    } catch (error) {
      log(error.toString());
      emit(ReportErrorState());
    }
  }

  void reportPostOrComment(String id) async {
    try {
      emit(ReportLoadingState());
      final Uri url = Uri.parse('$_baseUrl/report');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ??
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjBhYTMxNDg2NWIzOGM1YjdhMTYzNjEiLCJpYXQiOjE3MTE5NzY3MTksImV4cCI6MTcxMjA2MzExOX0.bTxxgNjfowVkRg2cRJaNMR-ITisqMm6V1V2yuIp_ZKA";
      var res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "itemID": id,
          "reportReason": _selectedReason,
          "reportDetails": controller.text
        }),
      );
      choseCurrentPage(3);
      log(res.body);
      emit(ReportSuccessState());
    } catch (error) {
      log(error.toString());
      emit(ReportErrorState());
    }
  }
}
