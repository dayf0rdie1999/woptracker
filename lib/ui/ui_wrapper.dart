import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/main.dart';
import 'package:woptracker/ui/auth_ui/signin_ui/signinbasewrapper.dart';
import 'package:woptracker/ui/basewidget.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_wrapper/woptracker_summary_stream_wrapper_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_wrapper/woptracker_summary_wrapper_ui.dart';
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseWidget(
      builder: (context,sizingInformation) {
        return ProviderScope(
          child: Consumer(
            builder: (context,ref,child) {
              // Todo: Getting the user
              AsyncValue<User?> _user = ref.watch(userProvider);

              if(_user.data != null) {
                if (_user.data!.value == null) {
                  return SignInUIWrapper();
                } else {
                  return WopTrackerSummaryStreamWrapperUI(user: _user.data!.value!,);
                }
              } else {
                return Loading();
              }
            }
          ),
        );
      }
    );
  }
}
