import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/main.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_tablet.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woptracker_tablet_wrapper/woptracker_tablet_stream_wrapper.dart';

class WopTrackerTabletAuthWrapper extends ConsumerWidget {
  const WopTrackerTabletAuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    AsyncValue<User?> data = ref.watch(userProvider);

    if(data.data != null) {
      if (data.data!.value != null) {
        return WopTrackerTabletStreamWrapperUI(user: data.data!.value!,);
      } else {
        return Loading();
      }
    } else {
      return Loading();
    }
  }
}
