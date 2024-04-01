import 'package:flutter/material.dart';

import 'about_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AboutHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            title: Text(
              'Send a message',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              Icons.chat,
              color: Colors.grey,
            ),
            title: Text(
              'Start Chat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            color: Colors.grey.shade300,
            child: const Text('TROPHIES'),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.three_g_mobiledata,
                  size: 40.0,
                  color: Colors.amber.shade900,
                ),
                const SizedBox(width: 10.0),
                const Text(
                  'Three-Year Club',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
