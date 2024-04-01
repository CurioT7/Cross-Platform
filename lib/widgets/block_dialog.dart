import 'package:curio/services/ahmed_api.dart';
import 'package:flutter/material.dart';

class BlockDialog extends StatelessWidget {
  const BlockDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: const Text('Block u/Thin-Performer-2560?'),
      content: const Text(
        'They won\'t be able to contact you or view your profile,posts, or comments.',
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            minimumSize: const MaterialStatePropertyAll(Size(120.0, 40.0)),
            backgroundColor: MaterialStatePropertyAll(Colors.grey.shade300),
            surfaceTintColor:
                const MaterialStatePropertyAll(Colors.transparent),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: const ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(120.0, 40.0)),
            backgroundColor: MaterialStatePropertyAll(Colors.red),
            surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: () {
            ApiService().blockUser('');
            Navigator.of(context).pop();
          },
          child: const Text('Block account'),
        ),
      ],
    );
  }
}
