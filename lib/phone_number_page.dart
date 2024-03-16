import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50.0,
                    child: Image.asset(
                        'images/signup.jpg'), // replace with your icon path
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign up or Login with your Phone Number',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  InternationalPhoneNumberInput(
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      setSelectorButtonAsPrefixIcon: true,
                      leadingPadding: 20,
                      useEmoji: true,
                    ),
                    hintText: 'Phone number',
                    validator: (userInput) {
                      if (userInput!.isEmpty) {
                        return 'Please enter your phone number';
                      }

                      // Ensure it is only digits and optional '+' or '00' for the country code.
                      if (!RegExp(r'^(\+|00)?[0-9]+$').hasMatch(userInput)) {
                        return 'Please enter a valid phone number';
                      }

                      // Remove '+' and '00' from the start of the userInput for length check
                      String phoneNumber = userInput.startsWith('+')
                          ? userInput.substring(1)
                          : userInput.startsWith('00')
                          ? userInput.substring(2)
                          : userInput;

                      // Check if the length of the phone number is at least 10 or 11.
                      if (phoneNumber.length < 10 || phoneNumber.length > 11) {
                        return 'Phone number should be 10 or 11 digits long';
                      }

                      return null; // Return null when the input is valid
                    },
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        this.number = number;
                      });
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, TextEditingValue text, child) {
                      return ElevatedButton(
                        onPressed: text.text.isEmpty
                            ? null
                            : () {
                          // Validate phone number input
                          print('Phone number: ${controller.text}');
                          print('Country code: ${number.isoCode}');
                          print('Country name: ${number.dialCode}');
                          print(
                              'valid? ${formKey.currentState?.validate()}');
                          // check if it is a valid phone number based on the countery selcted
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: text.text.isEmpty
                              ? Colors.grey
                              : Colors
                              .orange, // Orange color for button when enabled, grey when disabled
                          minimumSize: Size(double.infinity,
                              50), // Infinite width and height of 50
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Colors.white), // White text color
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
