import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_mobile.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_welcome_ui/woptracker_welcome_mobile_ui.dart';


class WopTrackerStreamMobileUI extends StatefulWidget {

  final User user;

  const WopTrackerStreamMobileUI({Key? key, required this.user}) : super(key: key);

  @override
  _WopTrackerStreamMobileUIState createState() => _WopTrackerStreamMobileUIState();
}

class _WopTrackerStreamMobileUIState extends State<WopTrackerStreamMobileUI> {

  final _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  late Stream<QuerySnapshot> _streamQuerySnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamQuerySnapshot = getStreamQuerySnapshot();
  }

  Stream<QuerySnapshot> getStreamQuerySnapshot() {
    return _storeService.getTracks(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamQuerySnapshot,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return WopTrackerMobileUI(user: widget.user, listDocumentSnapshot: documents,);
        }

        if(snapshot.hasError) {
          return Text("Something Wrong happens in WopTrackerStreamMobileUI");
        }

        return Loading();
      }
    );
  }
}
