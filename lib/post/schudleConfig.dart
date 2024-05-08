import 'package:curio/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'schudledPostPage.dart';

class SchedulePostBottomSheet extends StatefulWidget {
  Map<String, dynamic> post;
  Map<String, dynamic> community;
  SchedulePostBottomSheet(
      {super.key, required this.post, this.community = const {}});

  @override
  _SchedulePostBottomSheetState createState() =>
      _SchedulePostBottomSheetState();
}

class _SchedulePostBottomSheetState extends State<SchedulePostBottomSheet> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isRepeatingWeekly = false;
bool validateDateSelection(DateTime selectedDate, TimeOfDay selectedTime, BuildContext context) {
  DateTime now = DateTime.now();
  DateTime selectedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  if (selectedDateTime.isBefore(now)) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text(
              'Please select a date and time in the future',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        );
      },
    );

    return false;
  }
  return true;
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary:
                  Colors.black, // This will change the color of the OK button
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              colorScheme: ColorScheme.light(
                primary:
                    Colors.black, // This will change the color of the OK button
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Schedule Post',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {

                  // final SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // final String token = prefs.getString('token')!;
                  // final response = await ApiService()
                  //     .submitPost(widget.post, token, null);
                  // if (response['success'] == true) {
                  //   Navigator.pop(context);
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(response['message']),
                  //       duration: const Duration(seconds: 3),
                  //     ),
                  //   );
                  // }
                  // check the picked days/year and time
                  if (!validateDateSelection(selectedDate, selectedTime, context)) {
                    return;
                  }
                  selectedTime ??= TimeOfDay.now();
                  selectedDate ??= DateTime.now();

                  DateTime selectedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  String formattedDateTime =
                      selectedDateTime.toUtc().toIso8601String();
                  print(formattedDateTime);
                  widget.post['scheduledPublishDate'] = formattedDateTime;
                  widget.post['repeatOption'] =
                      isRepeatingWeekly ? 'weekly' : 'does_not_repeat';
                  widget.post['isScheduled'] = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduledPostsPage(
                          post: widget.post, community: widget.community),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Starts on: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                style: const TextStyle(color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Start at: ${selectedTime.format(context)}',
                style: const TextStyle(color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Repeat Weekly'),
              Switch(
                value: isRepeatingWeekly,
                onChanged: (value) {
                  setState(() {
                    isRepeatingWeekly = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
