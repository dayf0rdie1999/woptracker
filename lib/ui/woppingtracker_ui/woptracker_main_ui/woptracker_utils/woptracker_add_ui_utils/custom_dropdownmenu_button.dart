import 'package:flutter/material.dart';



class CustomDropDownMenuButton extends StatefulWidget {

  final int dropDownValue;

  final int listGeneratedValue;

  final Function(int value) updateDropDownValue;

  const CustomDropDownMenuButton({Key? key, required this.dropDownValue,required this.listGeneratedValue,required this.updateDropDownValue}) : super(key: key);

  @override
  _CustomDropDownMenuButtonState createState() => _CustomDropDownMenuButtonState();
}

class _CustomDropDownMenuButtonState extends State<CustomDropDownMenuButton> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.dropDownValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (newValue) {
        widget.updateDropDownValue(newValue!);
      },
      items: List.generate(widget.listGeneratedValue, (int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }),
    );
  }
}
