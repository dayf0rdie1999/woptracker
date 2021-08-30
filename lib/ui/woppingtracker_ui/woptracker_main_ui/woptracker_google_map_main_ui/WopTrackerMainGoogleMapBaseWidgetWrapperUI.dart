import 'package:flutter/material.dart';
import 'package:woptracker/ui/basewidget.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapUI.dart';


class WopTrackerMainGoogleMapBaseWidgetUI extends StatelessWidget {


  final Map<String,dynamic> data;

  final bool detailMode;

  const WopTrackerMainGoogleMapBaseWidgetUI({Key? key, required this.data, required this.detailMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        builder: (context,sizingInformation) {
          return WopTrackerGoogleMapUI(data: data,detailMode:  detailMode,isKsiWeb: sizingInformation.isKsiWeb!,);
        }
    );
  }
}
