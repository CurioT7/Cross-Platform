import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/report/report_cubit.dart';

class ReportUserOrPostBottomSheet extends StatelessWidget {
  const ReportUserOrPostBottomSheet({
    super.key,
    this.isUser = false,
    this.userName,
    this.id,
  });

  final bool isUser;
  final String? userName;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 5.0),
              Text(
                isUser ? 'Report Profile' : 'Submit a Report',
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    final ReportCubit reportCubit = context.read<ReportCubit>();
                    return reportCubit.getCurrentPage(isUser);
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                final ReportCubit reportCubit = context.read<ReportCubit>();
                if (state is ReportLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      if (!isUser) {
                        if (reportCubit.currentPage == 1 &&
                            reportCubit.selectedReason != null) {
                          reportCubit.choseCurrentPage(2);
                        } else if (reportCubit.currentPage == 2 &&
                            reportCubit.controller.text != '') {
                          reportCubit.reportPostOrComment(id ?? '');
                        }
                      } else {
                        if (reportCubit.currentPage == 1 &&
                            reportCubit.type != null) {
                          reportCubit.choseCurrentPage(2);
                        } else if (reportCubit.currentPage == 2 &&
                            reportCubit.selectedReason != null) {
                          reportCubit.choseCurrentPage(3);
                        } else if (reportCubit.currentPage == 3 &&
                            reportCubit.controller.text != '') {
                          reportCubit.reportProfile(userName ?? '');
                        }
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      backgroundColor: isUser
                          ? (reportCubit.currentPage == 1 &&
                                      reportCubit.type != null) ||
                                  (reportCubit.currentPage == 2 &&
                                      reportCubit.selectedReason != null) ||
                                  (reportCubit.currentPage == 3 &&
                                      reportCubit.problemText != null &&
                                      reportCubit.problemText != '')
                              ? const Color.fromARGB(255, 0, 67, 121)
                              : Colors.grey.shade200
                          : (reportCubit.currentPage == 1 &&
                                      reportCubit.selectedReason != null) ||
                                  (reportCubit.currentPage == 2 &&
                                      reportCubit.problemText != null &&
                                      reportCubit.problemText != '')
                              ? const Color.fromARGB(255, 0, 67, 121)
                              : Colors.grey.shade200,
                      surfaceTintColor: Colors.transparent,
                      foregroundColor: isUser
                          ? (reportCubit.currentPage == 1 &&
                                      reportCubit.type != null) ||
                                  (reportCubit.currentPage == 2 &&
                                      reportCubit.selectedReason != null) ||
                                  (reportCubit.currentPage == 3 &&
                                      reportCubit.problemText != null &&
                                      reportCubit.problemText != '')
                              ? Colors.white
                              : Colors.grey
                          : (reportCubit.currentPage == 1 &&
                                      reportCubit.selectedReason != null) ||
                                  (reportCubit.currentPage == 2 &&
                                      reportCubit.problemText != null &&
                                      reportCubit.problemText != '')
                              ? Colors.white
                              : Colors.grey,
                    ),
                    child: isUser
                        ? Text(
                            reportCubit.currentPage == 3 ? 'Submit' : 'Next',
                          )
                        : Text(
                            reportCubit.currentPage == 2 ? 'Submit' : 'Next',
                          ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
