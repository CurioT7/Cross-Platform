import 'package:flutter/material.dart';

class SortOptionsDialog extends StatefulWidget {
  final List<String> options;
  final Function(String) onOptionSelected;

  const SortOptionsDialog({
    Key? key,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _SortOptionsDialogState createState() => _SortOptionsDialogState();
}

class _SortOptionsDialogState extends State<SortOptionsDialog> {
  String _selectedOption = '';

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.options[0];
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: widget.options.map((option) {
            return ListTile(
              leading: _selectedOption == option ? const Icon(Icons.check) : null,
              title: Text(option),
              onTap: () {
                setState(() {
                  _selectedOption = option;
                });
                Navigator.pop(context);
                widget.onOptionSelected(option);
              },
            );
          }).toList(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showOptions,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Colors.grey,
      ),
      child: Text('Sort by $_selectedOption')
    );
  }
}