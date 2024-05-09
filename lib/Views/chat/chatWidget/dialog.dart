import 'package:flutter/material.dart';

class NewChatDialog extends StatefulWidget {
  final String username;
  final String token;
  final Function(String message, String media) onCreateChat;

  const NewChatDialog({
    super.key,
    required this.username,
    required this.token,
    required this.onCreateChat,
  });

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Chat'),
      content: TextField(
        controller: _messageController,
        decoration: const InputDecoration(
          hintText: 'Enter your message',
        ),
        maxLength: 255,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final message = _messageController.text.trim();
            if (message.length >= 3) {
              widget.onCreateChat(message, '');
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message must be at least 3 characters'),
                ),
              );
            }
          },
          child: const Text('Create Chat'),
        ),
      ],
    );
  }
}

