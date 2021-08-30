import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui.dart';


class WopTrackerAddUIWrapper extends StatefulWidget {

  final String userId;
  final String docId;
  final bool editMode;

  const WopTrackerAddUIWrapper({Key? key, required this.userId, required this.docId, required this.editMode}) : super(key: key);

  @override
  _WopTrackerAddUIWrapperState createState() => _WopTrackerAddUIWrapperState();
}

class _WopTrackerAddUIWrapperState extends State<WopTrackerAddUIWrapper> {

  // Todo: Initiate the StoreService class
  StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  // Creating a future document snapshot object
  late Stream<DocumentSnapshot> futureSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureSnapshot = _getTracker();
  }

  Stream<DocumentSnapshot> _getTracker() {
    return _storeService.getTracker(widget.userId, widget.docId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: futureSnapshot,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;

            return WopTrackerAddUI(docId: widget.docId, userId: widget.userId,data: data,editMode: widget.editMode,);
          }
        }
        if (snapshot.hasError) {
          return Text("Something Wrong Happens");
        }

        return Loading();
      }
    );
  }
}
