import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/google_map_ui/googlemapui.dart';

class GoogleMapWrapperUI extends StatefulWidget {

  final String userId;
  final String docId;

  final bool showFullScreen;

  final bool editMode;

  final Map<String,dynamic> data;

  const GoogleMapWrapperUI({Key? key,required this.userId, required this.docId, required this.data, required this.showFullScreen, required this.editMode}) : super(key: key);

  @override
  _GoogleMapWrapperUIState createState() => _GoogleMapWrapperUIState();
}

class _GoogleMapWrapperUIState extends State<GoogleMapWrapperUI> {

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  late Stream<DocumentSnapshot> _streamSnapshot;

  late Future<Position> _pos;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pos = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _pos,
        builder: (context,AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasError) {
            return Text("Something Went Wrong in GoogleMapUIWrapper");
          }

          else if (snapshot.data != null) {
            return GoogleMapUI(userPosition: snapshot.data!, userId: widget.userId, docId: widget.docId, data: widget.data, showFullScreen: widget.showFullScreen, editMode: widget.editMode);
          }

          return Loading();
        }
    );
  }
}


