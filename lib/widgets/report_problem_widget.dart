import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/report/report_cubit.dart';

class ReportProblemWidget extends StatelessWidget {
  const ReportProblemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        const Text(
          'Write your problem',
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 10.0),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            final ReportCubit reportCubit = context.read<ReportCubit>();
            return TextFormField(
              controller: reportCubit.controller,
              maxLines: 5,
              onChanged: (val) {
                reportCubit.getProblemText(val);
              },
              decoration: InputDecoration(
                hintText: 'Enter your reason here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
