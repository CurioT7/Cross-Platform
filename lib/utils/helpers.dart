import 'package:flutter/material.dart';
import 'package:curio/utils/reddit_colors.dart';



class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;

  const CustomTextField(
      this.labelText,
      this.controller, {
        this.obscureText = false,
        this.onChanged,
      });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? _isValid;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {
          if (widget.labelText == 'Email') {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern.toString());
            _isValid = regex.hasMatch(value);
          } else if (widget.labelText == 'Password') {
            _isValid = value.length >= 8;
          }
          else if (widget.labelText == 'Username') {
            _isValid = value.length >= 3;
            // TODO- check with the backend if the username is available
          }
        });
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        fillColor: redditGrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide.none, // Set border side to none
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide.none, // Set border side to none
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          borderSide: BorderSide(color: Colors.black), // Set border side to a visible color when focused
        ),
        suffixIcon: _isValid == null
            ? null
            : _isValid!
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.error, color: Colors.red),
      ),
      obscureText: widget.obscureText,
      validator: (value) {
        if (widget.labelText == 'Email') {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern.toString());
          if (!regex.hasMatch(value!))
            return 'Enter a valid email';
          else
            return null;
        } else if (widget.labelText == 'Password') {
          if (value!.length < 8)
            return 'Password must be longer than 8 characters';
          else
            return null;
        }
        return null;
      },
    );
  }
}