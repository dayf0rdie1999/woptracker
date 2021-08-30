import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_desktop.dart';

class WopTrackerDesktopStreamWrapperUI extends StatefulWidget {

  final User user;
  const WopTrackerDesktopStreamWrapperUI({Key? key, required this.user}) : super(key: key);

  @override
  _WopTrackerDesktopStreamWrapperUIState createState() => _WopTrackerDesktopStreamWrapperUIState();
}

class _WopTrackerDesktopStreamWrapperUIState extends State<WopTrackerDesktopStreamWrapperUI> {

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  late Stream<QuerySnapshot> streamSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamSnapshot = getTrack();
  }

  Stream<QuerySnapshot> getTrack() {
    return _storeService.getTracks(widget.user.uid);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSnapshot,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;

            return WopTrackerDesktopUI(user: widget.user,documents: documents,receivedData: null, );
          }
        }

        else if (snapshot.hasError) {
          return Text("Something wrong with Wop Tracker Stream Wrapper UI");
        }

        return Loading();
      }
    );
  }
}
