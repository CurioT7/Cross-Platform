import 'package:flutter/material.dart';

import 'report_reason_item.dart';

class ChoseReasonWidget extends StatelessWidget {
  const ChoseReasonWidget({
    super.key,
    required List<String> items,
  }) : _items = items;

  final List<String> _items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thanks for looking out for yourself and your fellow curioers by reporting thing that break the rules. Let us Know what\'s happening, and we\'ll look into it.',
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 10.0,
          runSpacing: 20.0,
          children: _items
              .map(
                (item) => ReportReasonItem(title: item),
              )
              .toList(),
        ),
      ],
    );
  }
}
