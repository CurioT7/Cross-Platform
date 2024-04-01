import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';

class ReportBottomSheet extends StatelessWidget {
  const ReportBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 60.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey,
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
              const SizedBox(width: 10.0),
              const Text(
                'Report Profile',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
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
            trailing: Radio(
              value: true,
              groupValue: bool,
              onChanged: (val) {},
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Avatar/Profile Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Radio(
              value: true,
              groupValue: bool,
              onChanged: (val) {},
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              ApiService().reportUser();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50.0),
              backgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.grey,
              surfaceTintColor: Colors.transparent,
            ),
            child: const Text('Next'),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
