import 'package:curio/controller/history_cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentBottomSheet extends StatelessWidget { 
  const RecentBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          final HistoryCubit historyCubit = context.read<HistoryCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('SORT HISTORY BY'),
              const Divider(),
              ...historyCubit.sortItems.map(
                (item) => ListTile(
                  onTap: () {
                    historyCubit.choseSort(context, item);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item['icon']),
                  title: Text(
                    item['title'],
                    style: historyCubit.selectedSort == item
                        ? const TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        : null,
                  ),
                  trailing: historyCubit.selectedSort == item
                      ? const Icon(
                          Icons.done,
                          color: Colors.blue,
                        )
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
