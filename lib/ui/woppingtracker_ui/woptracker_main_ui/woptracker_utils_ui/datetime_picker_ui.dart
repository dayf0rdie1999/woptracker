import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class WopTrackerDatePicker extends StatefulWidget {

  final DateTime selectedDate;
  final VoidCallback updateSelectedDate;
  const WopTrackerDatePicker({Key? key, required this.selectedDate, required this.updateSelectedDate}) : super(key: key);

  @override
  _WopTrackerDatePickerState createState() => _WopTrackerDatePickerState();
}

class _WopTrackerDatePickerState extends State<WopTrackerDatePicker> {


  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Enter Date: ",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        TextButton(
          onPressed: widget.updateSelectedDate,
          child: Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
              child: Text(
                formatter.format(widget.selectedDate),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}