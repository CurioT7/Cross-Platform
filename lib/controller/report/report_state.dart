part of './report_cubit.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ChoseReasonState extends ReportState {}

class ChangeCurrentPageState extends ReportState {}

class ChangeReportProfileTypeState extends ReportState {}

class GetProblemTextState extends ReportState {}

class ReportLoadingState extends ReportState {}

class ReportSuccessState extends ReportState {}

class ReportErrorState extends ReportState {}
