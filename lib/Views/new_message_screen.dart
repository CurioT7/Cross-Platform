import 'package:flutter/material.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('New Message'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'SEND',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'u/',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Divider(color: Colors.grey),
            SizedBox(height: 5.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Subject',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5.0),
            Divider(color: Colors.grey),
            SizedBox(height: 5.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Message',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              maxLines: 10,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
