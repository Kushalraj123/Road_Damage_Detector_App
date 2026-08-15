import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/road_segment.dart';

class RoadSegmentService {
  static const String baseUrl = "https://routefixer.dpdns.org/api";

  Future<List<RoadSegment>> fetchSegments({
    required double latitude,
    required double longitude,
    required int zoom,
  }) async {
    final uri = Uri.parse("$baseUrl/road-segments/map/").replace(
      queryParameters: {
        'lat': latitude.toStringAsFixed(6),
        'lng': longitude.toStringAsFixed(6),
        'zoom': zoom.toString(),
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception("API failed: ${response.statusCode}");
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RoadSegment.fromJson(e)).toList();
    } catch (e) {
      print("Network error fetching road segments, generating mock segments around center: $e");
      return [
        RoadSegment(
          id: 1,
          roadName: "Beach Road Segment",
          locality: "Kozhikode Beach",
          city: "Kozhikode",
          severity: "high",
          points: [
            LatLng(latitude - 0.003, longitude - 0.003),
            LatLng(latitude, longitude),
            LatLng(latitude + 0.003, longitude + 0.003),
          ],
        ),
        RoadSegment(
          id: 2,
          roadName: "Mavoor Road Segment",
          locality: "Mavoor Road",
          city: "Kozhikode",
          severity: "medium",
          points: [
            LatLng(latitude + 0.003, longitude - 0.004),
            LatLng(latitude + 0.001, longitude - 0.001),
            LatLng(latitude, longitude - 0.003),
          ],
        ),
        RoadSegment(
          id: 3,
          roadName: "Bypass Highway Segment",
          locality: "Thondayad Bypass",
          city: "Kozhikode",
          severity: "low",
          points: [
            LatLng(latitude - 0.002, longitude + 0.004),
            LatLng(latitude - 0.001, longitude + 0.002),
            LatLng(latitude + 0.001, longitude + 0.001),
          ],
        ),
      ];
    }
  }
}
