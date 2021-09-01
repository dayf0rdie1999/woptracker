import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/enums/devicescreentype.dart';
import 'package:woptracker/ui/basewidget.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_desktop_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_mobile_ui.dart';

class WopTrackerSummaryWrapperUI extends StatelessWidget {

  final User user;

  final List<DocumentSnapshot> documents;

  const WopTrackerSummaryWrapperUI({Key? key, required this.user, required this.documents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
           return WopTrackerSummaryMobileUI(user: user, documents: documents,);
          } else if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
            return WopTrackerSummaryMobileUI(user: user, documents: documents,);
          } else{
            return WopTrackerSummaryDesktopUI(user: user, documents: documents);
          }
        }
    );
  }
}
