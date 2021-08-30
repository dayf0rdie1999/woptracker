import 'package:flutter/material.dart';


class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Color labelColor;

  const CustomTextFormField({Key? key, required this.controller, required this.labelText, required this.obscureText, required this.labelColor}) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      obscureText: widget.obscureText,
      style: TextStyle(
        color: Colors.white,
      ),
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        labelStyle: TextStyle(
          color: widget.labelColor,
        ),
        labelText: "Enter ${widget.labelText} *",
      ),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return "Input Required";
        } else {
          return null;
        }
      },
    );
  }
}