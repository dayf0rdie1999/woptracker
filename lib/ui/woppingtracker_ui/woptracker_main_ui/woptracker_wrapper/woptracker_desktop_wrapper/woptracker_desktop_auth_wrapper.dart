import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/main.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_desktop.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_desktop_wrapper/woptracker_desktop_stream_wrapper.dart';

class WopTrackerDesktopAuthWrapperUI extends ConsumerWidget {
  const WopTrackerDesktopAuthWrapperUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    AsyncValue<User?> result = ref.watch(userProvider);

    if (result.data != null && result.data!.value != null) {
      return WopTrackerDesktopStreamWrapperUI(user: result.data!.value!,);
    } else {
      return Loading();
    }

  }
}
