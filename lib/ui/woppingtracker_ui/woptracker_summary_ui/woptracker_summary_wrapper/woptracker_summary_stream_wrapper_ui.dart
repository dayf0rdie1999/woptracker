import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_wrapper/woptracker_summary_wrapper_ui.dart';


class WopTrackerSummaryStreamWrapperUI extends StatefulWidget {

  final User user;

  const WopTrackerSummaryStreamWrapperUI({Key? key, required this.user}) : super(key: key);

  @override
  _WopTrackerSummaryStreamWrapperUIState createState() => _WopTrackerSummaryStreamWrapperUIState();
}

class _WopTrackerSummaryStreamWrapperUIState extends State<WopTrackerSummaryStreamWrapperUI> {

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  late Stream<QuerySnapshot> streamTodayTracks;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamTodayTracks = getTodayTracks();
  }


  Stream<QuerySnapshot> getTodayTracks() {
    return _storeService.getTodayTracks(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamTodayTracks,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if(snapshots.hasError){
          return Text("Something Wrong Connecting to the database");
        }

        if (snapshots.connectionState == ConnectionState.active) {
          if (snapshots.data != null) {

            return WopTrackerSummaryWrapperUI(user: widget.user,documents: snapshots.data!.docs,);
          } else {
            return Loading();
          }
        }

        return Loading();
    });
  }
}
