import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.reddit,
            size: 50.0,
            color: Colors.grey,
          ),
          SizedBox(height: 5.0),
          Text('Wow, such empty'),
        ],
      ),
    );
  }
}
