import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_tablet.dart';

class WopTrackerTabletStreamWrapperUI extends StatefulWidget {

  final User user;

  const WopTrackerTabletStreamWrapperUI({Key? key, required this.user}) : super(key: key);

  @override
  _WopTrackerTabletStreamWrapperUIState createState() => _WopTrackerTabletStreamWrapperUIState();
}

class _WopTrackerTabletStreamWrapperUIState extends State<WopTrackerTabletStreamWrapperUI> {

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  late Stream<QuerySnapshot> streamQuerySnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamQuerySnapshot = getTrack();
  }

  Stream<QuerySnapshot> getTrack() {
    return _storeService.getTracks(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: streamQuerySnapshot,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            return WopTrackerTabletUI(user: widget.user, listDocumentSnapshot: documents);

          } else {
            return Loading();
          }
        }

        if (snapshot.hasError) {
          return Text("Something Wrong With WopTrackerTabletStreamUI");
        }

        return Loading();
      }
    );
  }
}
