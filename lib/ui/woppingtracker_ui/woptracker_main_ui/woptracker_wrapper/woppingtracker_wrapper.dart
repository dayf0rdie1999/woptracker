import 'package:flutter/material.dart';
import 'package:woptracker/enums/devicescreentype.dart';
import 'package:woptracker/ui/basewidget.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_desktop_wrapper/woptracker_desktop_auth_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_mobile_wrapper/woptracker_mobile_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_tablet_wrapper/woptracker_tablet_auth_wrapper.dart';



class WopTrackerWrapperUI extends StatelessWidget {
  const WopTrackerWrapperUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        builder: (context,sizingInformation) {

          if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
            return WopTrackerMobileWrapper();
          }
          else if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
            return WopTrackerTabletAuthWrapper();
          } else {
            return WopTrackerDesktopAuthWrapperUI();
          }

        },
    );
  }
}
