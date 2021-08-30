import 'package:flutter/material.dart';
import 'package:woptracker/enums/devicescreentype.dart';
import 'package:woptracker/ui/auth_ui/signup_ui/signup.dart';
import 'package:woptracker/ui/basewidget.dart';

class SignUpUIWrapper extends StatelessWidget {
  const SignUpUIWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background_image.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop)
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: BaseWidget(
          builder: (context,sizingInformation) {
            if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
              return SignUpUI();
            } else if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
              return SignUpUI();
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: sizingInformation.screenSize!.width/4),
                child: SignUpUI(),
              );
            }
          }
        ),
      ),
    );
  }
}

