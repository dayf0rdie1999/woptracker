import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapBaseWidgetWrapperUI.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapUI.dart';


class WopTrackerMobileDetailUI extends StatefulWidget {

  final Map<String,dynamic> data;

  const WopTrackerMobileDetailUI({Key? key, required this.data}) : super(key: key);

  @override
  _WopTrackerMobileDetailUIState createState() => _WopTrackerMobileDetailUIState();
}

class _WopTrackerMobileDetailUIState extends State<WopTrackerMobileDetailUI> {

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(
        children: <Widget>[
          WopTrackerMainGoogleMapBaseWidgetUI(data: widget.data, detailMode: true),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
              child: Card(
                color: Colors.yellow[600],
                child: SizedBox(
                  width: 100.0,
                  height: 40.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.data["track_name"]),
                        Text(formatter.format(DateTime.fromMicrosecondsSinceEpoch(widget.data["track_date"].microsecondsSinceEpoch))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
