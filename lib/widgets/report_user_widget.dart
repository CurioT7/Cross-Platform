import 'package:curio/controller/report/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportUserWidget extends StatelessWidget {
  const ReportUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final ReportCubit reportCubit = context.read<ReportCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What do you want to report?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Radio<ReportProfileType?>(
                groupValue: reportCubit.type,
                value: ReportProfileType.username,
                onChanged: reportCubit.choseReportProfileType,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Avatar/Profile Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Radio<ReportProfileType?>(
                groupValue: reportCubit.type,
                value: ReportProfileType.profileImage,
                onChanged: reportCubit.choseReportProfileType,
              ),
            ),
          ],
        );
      },
    );
  }
}
