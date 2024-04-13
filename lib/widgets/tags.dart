import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class TagBottomSheet extends StatefulWidget {
  final Function(List<String>) onDismiss;
  final List<String> selectedTags;
  TagBottomSheet({required this.onDismiss, required this.selectedTags});

  @override
  _TagBottomSheetState createState() => _TagBottomSheetState();
}
class _TagBottomSheetState extends State<TagBottomSheet> {
  late List<String> selectedTags;

  @override
  void initState() {
    super.initState();
    selectedTags = List.from(widget.selectedTags);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add Tags',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.onDismiss(selectedTags);
                  Navigator.pop(context); // Add this line
                },
              ),
            ],
          ),
          TagBar(
            icon: FontAwesomeIcons.triangleExclamation,
            tagName: 'Spoiler',
            info: 'Spoiler Alert',
            value: selectedTags.contains('Spoiler'),
            onChanged: (bool value) {
              if (value) {
                selectedTags.add('Spoiler');
              } else {
                selectedTags.remove('Spoiler');
              }
            },
          ),
          TagBar(
            icon: FontAwesomeIcons.circleExclamation,
            tagName: 'NSFW',
            info: 'Not Safe For Work',
            value: selectedTags.contains('NSFW'),
            onChanged: (bool value) {
              if (value) {
                selectedTags.add('NSFW');
              } else {
                selectedTags.remove('NSFW');
              }
            },
          ),
          TagBar(
            icon: FontAwesomeIcons.circleExclamation,
            tagName: 'isOC',
            info: 'Original Content',
            value: selectedTags.contains('isOC'),
            onChanged: (bool value) {
              if (value) {
                selectedTags.add('isOC');
              } else {
                selectedTags.remove('isOC');
              }
            },
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}

class TagBar extends StatefulWidget {
  final IconData icon;
  final String tagName;
  final String info;
  final ValueChanged<bool> onChanged;
  bool value;

  TagBar({
    required this.icon,
    required this.tagName,
    required this.info,
    required this.onChanged,
    required this.value,
  });

  @override
  _TagBarState createState() => _TagBarState();
}

class _TagBarState extends State<TagBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Icon(widget.icon),
              const SizedBox(width: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.tagName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.info,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100, // specify the width you want
          child: Stack(
            alignment: Alignment.center,
            children: [
              Switch(
                trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey[200];
                    }
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue;
                    }
                    return Colors.grey[200];                  },
                ),
                thumbColor: MaterialStateProperty.all(Colors.white),
                inactiveThumbColor: Colors.white,
                value: widget.value,
                onChanged: (bool newValue) {
                  widget.onChanged(newValue);
                  setState(() {
                    widget.value = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

