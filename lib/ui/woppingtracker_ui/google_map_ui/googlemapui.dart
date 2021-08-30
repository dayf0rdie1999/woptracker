import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:woptracker/googlemap_directions/directions_model.dart';
import 'package:woptracker/googlemap_directions/directions_repository_2.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/basewidget.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui_wrapper.dart';


class GoogleMapUI extends StatefulWidget {


  final Position userPosition;

  final String userId;
  final String docId;

  final Map<String,dynamic> data;

  final bool showFullScreen;

  final bool editMode;

  const GoogleMapUI({Key? key, required this.userPosition, required this.userId, required this.docId, required this.data, required this.showFullScreen, required this.editMode}) : super(key: key);

  @override
  _GoogleMapUIState createState() => _GoogleMapUIState();
}

class _GoogleMapUIState extends State<GoogleMapUI> {
  
  final _authService = AuthService(auth: FirebaseAuth.instance);

  late GoogleMapController _controller;

  Marker? _origin;
  Marker? _destination;

  LatLng? _originCor;
  LatLng? _destinationCor;

  Circle? _wopCircle;

  // Todo: Creating Store Service
  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  String snackBarText = "";

  // Todo: Creating a function to check whether the coordinates are there
  void getTracker() {

    if (widget.data["track"] != null) {
      _originCor = LatLng(widget.data["track"]["origin"][1],widget.data["track"]["origin"][0]);
      _destinationCor = LatLng(widget.data["track"]["destination"][1],widget.data["track"]["destination"][0]);

      _addMarker(LatLng(widget.data["track"]["origin"][1],widget.data["track"]["origin"][0]));
      _addMarker(LatLng(widget.data["track"]["destination"][1],widget.data["track"]["destination"][0]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTracker();
  }

  @override
  Widget build(BuildContext context) {

    final snackBar = SnackBar(content: Text(snackBarText),);
    try {
      return Scaffold(
        appBar: (widget.showFullScreen) ? AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>
                    WopTrackerAddUIWrapper(userId: widget.userId,
                      docId: widget.docId,
                      editMode: widget.editMode,)),
              );
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_originCor != null && _destinationCor != null) {
                    // Creating a map
                    var posMap = {
                      'origin': [
                        _originCor!.longitude,
                        _originCor!.latitude
                      ],
                      'destination': [
                        _destinationCor!.longitude,
                        _destinationCor!.latitude
                      ]
                    };

                    String? result = await _storeService.updateTracker(
                        "track", posMap, widget.userId, widget.docId);

                    if (result != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            WopTrackerAddUIWrapper(userId: widget.userId,
                              docId: widget.docId,
                              editMode: widget.editMode,)
                        ),
                      );
                    } else {
                      setState(() {
                        snackBarText = "Can't update data to the server";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    setState(() {
                      snackBarText = "Missing Inputting Track";
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text("Save"),
              ),
            ),
          ],
        ): null,
        body: GoogleMap(
          mapType: MapType.normal,
          markers: {
            if(_origin != null) _origin!,
            if(_destination != null) _destination!,
          },
          zoomControlsEnabled: (widget.showFullScreen) ? true : false,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          onTap: (LatLng pos) {
            _addMarker(pos);
          },
          circles: {
            if (_wopCircle != null) _wopCircle!,
          },
          initialCameraPosition:  (widget.data["track"] != null) ? CameraPosition(target: getCenter(),zoom: 15,) : CameraPosition(target: LatLng(widget.userPosition.latitude,widget.userPosition.longitude), zoom: 15,),
        ),
      );
    } catch (e) {
      return Loading();
    }

  }

  void _addMarker(LatLng pos) async {

    if (_origin == null || (_origin != null && _destination != null)) {

      _originCor = LatLng(pos.latitude, pos.longitude);
      // Setting Origin
      setState(() {
        _origin = Marker(
          onTap: () {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _origin!.position,
                zoom: 14.5,
                tilt: 50.0,
              ),
            ),
            );
          },
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: 'Origin | Lat: ${pos.latitude} Long: ${pos.longitude}'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );



        _destination = null;
        _wopCircle = null;

      });
      
    } else {

      _destinationCor = LatLng(pos.latitude, pos.longitude);
      // Setting Destination
      setState(() {
        _destination = Marker(
          onTap: () {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _destination!.position,
                zoom: 14.5,
                tilt: 50.0,
              ),
            ),
            );
          },
          markerId: MarkerId("Destination"),
          infoWindow: InfoWindow(title: 'Destination | Lat: ${pos.latitude} Long: ${pos.longitude}'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );

      });

      // Get directions
      setState(() {
        _wopCircle = Circle(
          circleId: CircleId("WopRange"),
          center: getCenter(),
          radius: getRadius(),
          strokeWidth: 5,
          fillColor: Colors.blueAccent.withOpacity(0.5),
          strokeColor: Colors.blueAccent.withOpacity(0.5),
        );

      });



      _origin = null;
      _destination = null;
    }

  }

  LatLng getCenter() {

    var latCenter = (_originCor!.latitude + _destinationCor!.latitude)/2;
    var longCenter = (_originCor!.longitude + _destinationCor!.longitude)/2;

    return LatLng(latCenter, longCenter);
  }

  double getRadius() {

    var latCenter = (_origin!.position.latitude + _destination!.position.latitude)/2;
    var longCenter = (_origin!.position.longitude + _destination!.position.longitude)/2;


    var gcd = GreatCircleDistance.fromDegrees(latitude1: latCenter,longitude1: longCenter,latitude2: _destination!.position.latitude,longitude2: _destination!.position.longitude);

    return gcd.haversineDistance();
  }

}
