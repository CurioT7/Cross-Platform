import 'package:flutter/material.dart';

class PollComponent extends StatefulWidget {
  final VoidCallback onClear;
  final GlobalKey<_PollComponentState> pollComponentKey;

  const PollComponent({required this.pollComponentKey, required this.onClear}) : super(key: pollComponentKey);

  @override
  _PollComponentState createState() => _PollComponentState();

  List<String>? getOptions() {
    return pollComponentKey.currentState?.getOptions();
  }

  String? getSelectedOption() {
    return pollComponentKey.currentState?.getSelectedOption();
  }
}

class _PollComponentState extends State<PollComponent> {
  List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  List<String> getOptions() {
    // give a default value of the text if nontext is entered
    return optionControllers.map((controller) => controller.text.isEmpty ? 'Option' : controller.text).toList();
  }

  String getSelectedOption() {
    return selectedOption;
  }

  String selectedOption = '3 days';
  List<FocusNode> optionFocusNodes = [FocusNode(), FocusNode()];
  List<UniqueKey> optionKeys = [UniqueKey(), UniqueKey()]; // Add this line
  void _showEndPollOptions() async {
    int? selectedRadio = int.parse(selectedOption.split(' ')[0]);
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Radio<int>(
                          value: index + 1,
                          groupValue: selectedRadio,
                          onChanged: (int? value) {
                            setModalState(() {
                              selectedRadio = value;
                            });
                          },
                        ),
                        title: Text('${index + 1} days',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          setModalState(() {
                            selectedRadio = index + 1;
                          });
                          Navigator.pop(context, index + 1);
                        },
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: const Text('Close',
                        style: TextStyle(color: Colors.brown)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedOption = '$result days';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Poll will end in ',
                      style:
                      const TextStyle(fontSize: 12, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: selectedOption,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero, // Add this line
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: _showEndPollOptions,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClear,
              ),
            ],
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: optionControllers.length,
              itemBuilder: (context, index) {
                return Container(
                  key: optionKeys[index], // Use the unique key here
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: optionControllers[index],
                          focusNode: optionFocusNodes[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              optionControllers[index].text = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            optionControllers.removeAt(index);
                            optionFocusNodes.removeAt(index);
                            optionKeys.removeAt(index); // Add this line
                          });
                          if (optionControllers.isEmpty) {
                            widget.onClear();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final controller = optionControllers.removeAt(oldIndex);
                  optionControllers.insert(newIndex, controller);
                  final focusNode = optionFocusNodes.removeAt(oldIndex);
                  optionFocusNodes.insert(newIndex, focusNode);
                  final key = optionKeys.removeAt(oldIndex); // Add this line
                  optionKeys.insert(newIndex, key); // Add this line
                });
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                optionControllers.add(TextEditingController());
                optionFocusNodes.add(FocusNode());
                optionKeys.add(UniqueKey()); // Add this line
              });
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                optionFocusNodes.last.requestFocus();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.all(1.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add, color: Colors.brown),
                  SizedBox(width: 5), // Adjust the space as needed
                  Text(
                    'Add Option',
                    style: TextStyle(
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
