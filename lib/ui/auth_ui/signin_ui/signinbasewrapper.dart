import 'package:flutter/material.dart';
import 'package:woptracker/enums/devicescreentype.dart';
import 'package:woptracker/ui/auth_ui/signin_ui/signin.dart';
import 'package:woptracker/ui/basewidget.dart';

class SignInUIWrapper extends StatelessWidget {
  const SignInUIWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop)
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body:BaseWidget(
            builder: (context,sizingInformation) {
              if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
                return SignInUI();
              } else if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
                return SignInUI();
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizingInformation.screenSize!.width/4),
                  child: SignInUI(),
                );
              }
            }
        ),
      ),
    );
  }
}
