import 'package:flutter/material.dart';

class WopTrackerWelcomeUI extends StatefulWidget {

  const WopTrackerWelcomeUI({Key? key}) : super(key: key);

  @override
  _WopTrackerWelcomeUIState createState() => _WopTrackerWelcomeUIState();
}

class _WopTrackerWelcomeUIState extends State<WopTrackerWelcomeUI> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Begin the Wopping Journey",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )
    );
  }
}
