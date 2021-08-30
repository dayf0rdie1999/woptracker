import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:woptracker/googlemap_directions/directions_model.dart';
import '.env.dart';


class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({ required Dio dio}) : _dio = dio;

  Future<Directions?> getDirections({
  required LatLng origin,
  required LatLng destination,
  }) async {
    try {

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleAPIKey,
        },
      );

      return Directions.fromMap(response.data);
    }catch (e) {
      print(e);
    }

    return null;
  }

}