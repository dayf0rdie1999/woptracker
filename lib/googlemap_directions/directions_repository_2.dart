import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:woptracker/googlemap_directions/directions_model.dart';

class DirectionsRepositoryHttp {
  // static const String _baseUrl =
  //     'https://maps.googleapis.com/maps/api/directions/json?';

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
    required String baseUrl,
    required String googleApiKey,
  }) async {

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleApiKey,
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return Directions.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load directions');
    }

  }

}