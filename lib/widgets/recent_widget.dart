import 'package:curio/controller/history_cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recent_bottom_sheet.dart';

class RecentWidget extends StatelessWidget {
  const RecentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const RecentBottomSheet();
                  },
                );
              },
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  final HistoryCubit historyCubit =
                      context.read<HistoryCubit>();
                  return Row(
                    children: [
                      Icon(historyCubit.selectedSort['icon']),
                      const SizedBox(width: 5.0),
                      Text(historyCubit.selectedSort['title']),
                      const SizedBox(width: 5.0),
                      const Icon(Icons.keyboard_arrow_down_outlined),
                      const Spacer(),
                    ],
                  );
                },
              ),
            ),
          ),
          const Icon(Icons.list),
        ],
      ),
    );
  }
}
