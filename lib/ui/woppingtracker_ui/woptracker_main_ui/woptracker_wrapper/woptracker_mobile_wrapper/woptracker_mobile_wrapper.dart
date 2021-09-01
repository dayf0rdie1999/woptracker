import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/main.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_mobile_wrapper/woppingtracker_stream_wrapper.dart';


class WopTrackerMobileWrapper extends ConsumerWidget {
  const WopTrackerMobileWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    AsyncValue<User?> _user = ref.watch(userProvider);
    
    if(_user.data != null) {
      return WopTrackerStreamMobileUI(user: _user.data!.value!);
    } else {
      return Loading();
    }
  }
}
