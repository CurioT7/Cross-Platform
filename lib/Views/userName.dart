import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:animate_do/animate_do.dart';

class CreateUsernamePage extends StatefulWidget {
  @override
  _CreateUsernamePageState createState() => _CreateUsernamePageState();
}
class _CreateUsernamePageState extends State<CreateUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool? _isUsernameAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Username'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FadeInUp(
            child: Center( // Wrap the Column widget with a Center widget
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50.0,
                    child: Image.asset('images/signup.jpg'),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            helperText: _isUsernameAvailable == null
                                ? null
                                : (_isUsernameAvailable?? false)
                                ? 'Username is available'
                                : 'Username is taken',
                            suffixIcon: _isUsernameAvailable == null
                                ? null
                                : _isUsernameAvailable?? false
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.error, color: Colors.red),
                          ),
                          onChanged: (value) async {
                            if (value.isEmpty) {
                              _isUsernameAvailable = null;
                            } else {
                              // -DEBUGGING-
                              // final apiService = ApiService();
                              // final response = await apiService.isUsernameAvailable(value);
                              _isUsernameAvailable = true;
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20), // Add a SizedBox widget for padding
                        ElevatedButton(
                          onPressed: _isUsernameAvailable == true ? _continue : null,
                          child: Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _continue() {
    if (_formKey.currentState!.validate()) {
      // Navigate back to the first page
      Navigator.pop(context);
    }
  }
}