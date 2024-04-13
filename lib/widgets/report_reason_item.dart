import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/report/report_cubit.dart';

class ReportReasonItem extends StatelessWidget {
  const ReportReasonItem({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final ReportCubit reportCubit = context.read<ReportCubit>();
        return InkWell(
          onTap: () => reportCubit.choseReason(title),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: reportCubit.selectedReason == title
                  ? const Color.fromARGB(255, 0, 67, 121)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: reportCubit.selectedReason == title
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
