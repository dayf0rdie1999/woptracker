import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:woptracker/googlemap_directions/directions_model.dart';
import 'package:woptracker/googlemap_directions/directions_repository_2.dart';

class WopTrackerGoogleMapUI extends StatefulWidget {

  final Map<String,dynamic> data;

  final bool detailMode;

  final bool isKsiWeb;

  const WopTrackerGoogleMapUI({Key? key, required this.data, required this.detailMode, required this.isKsiWeb}) : super(key: key);

  @override
  _WopTrackerGoogleMapUIState createState() => _WopTrackerGoogleMapUIState();
}

class _WopTrackerGoogleMapUIState extends State<WopTrackerGoogleMapUI> {

  late GoogleMapController _controller;

  Marker? _origin;
  Marker? _destination;

  Circle? _wopCircle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrackData();
  }

  void getTrackData() {

    if(widget.data["track"] != null) {
      _addMarker(LatLng(widget.data["track"]["origin"][1],widget.data["track"]["origin"][0]));
      _addMarker(LatLng(widget.data["track"]["destination"][1],widget.data["track"]["destination"][0]));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          markers: {
            if(_origin != null) _origin!,
            if(_destination != null) _destination!,
          },
          zoomControlsEnabled: (widget.detailMode == false) ? false :true,
          initialCameraPosition: CameraPosition(target: getCenter(), zoom: 14.5),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          circles: {
            if(_wopCircle != null) _wopCircle!,
          },
        ),
      ],
    );
  }


  void _addMarker(LatLng pos) async {

    if (_origin == null || (_origin != null && _destination != null)) {
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
        // Reset the destination
        _destination = null;
      });
    } else {
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
          infoWindow: InfoWindow(title: 'Destination | Lat: ${pos.latitude} Long: ${pos.longitude}' ,),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );

      });


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

    }
  }

  LatLng getCenter() {

    var latCenter = (_origin!.position.latitude + _destination!.position.latitude)/2;
    var longCenter = (_origin!.position.longitude + _destination!.position.longitude)/2;

    return LatLng(latCenter, longCenter);
  }

  double getRadius() {

    var latCenter = (_origin!.position.latitude + _destination!.position.latitude)/2;
    var longCenter = (_origin!.position.longitude + _destination!.position.longitude)/2;


    var gcd = GreatCircleDistance.fromDegrees(latitude1: latCenter,longitude1: longCenter,latitude2: _destination!.position.latitude,longitude2: _destination!.position.longitude);

    return gcd.haversineDistance();
  }

}
