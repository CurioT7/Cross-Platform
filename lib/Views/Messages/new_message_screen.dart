import 'package:flutter/material.dart';
import 'package:curio/services/messageService.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({Key? key}) : super(key: key);

  @override
  _NewMessageScreenState createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('New Message'),
        actions: [
          TextButton(
            onPressed: () async {
              final messageService = ApiService();
              await messageService.sendMessage(
                recipient: _usernameController.text,
                subject: _subjectController.text,
                message: _messageController.text,
                sendToSubreddit: false, // Update this as per your requirement
              );
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) { // Use a different BuildContext
                  return AlertDialog(
                    title: Text('Message sent'),
                    content: Text('Message sent successfully!'),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: Colors.black), // Set the color to black
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          Navigator.of(context).pop(); // Close the screen
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'SEND',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'u/',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              const Divider(color: Colors.grey),
              const SizedBox(height: 5.0),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  hintText: 'Subject',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5.0),
              const Divider(color: Colors.grey),
              const SizedBox(height: 5.0),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Message',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 10,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}