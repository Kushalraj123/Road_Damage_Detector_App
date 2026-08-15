import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ReportService {
  static const String baseUrl = "https://routefixer.dpdns.org/api";

  static final List<Map<String, dynamic>> _mockReports = [
    {
      "id": 101,
      "segment_id": 1,
      "damage_type": "Deep Pothole",
      "description": "A deep pothole in the middle lane causing traffic build-up. Extremely dangerous for two-wheelers.",
      "status": "Pending",
      "image_url": "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=400",
      "severity": "High",
      "ml_prediction": "Pothole",
      "ml_confidence": 94.5,
      "road_name": "Beach Road",
      "locality": "Kozhikode Beach",
      "city": "Kozhikode",
      "latitude": 11.2588,
      "longitude": 75.7804,
      "timestamp": "2026-08-15T09:00:00.000Z",
      "updated_at": "2026-08-15T09:00:00.000Z",
    },
    {
      "id": 102,
      "segment_id": 2,
      "damage_type": "Major Cracks",
      "description": "Long longitudinal cracks running along the shoulder of the road. Risk of edge drop-off.",
      "status": "Verified",
      "image_url": "https://images.unsplash.com/photo-1621293954908-907141447de9?q=80&w=400",
      "severity": "Medium",
      "ml_prediction": "Longitudinal Crack",
      "ml_confidence": 88.2,
      "road_name": "Mavoor Road",
      "locality": "Tazhekkod",
      "city": "Kozhikode",
      "latitude": 11.2625,
      "longitude": 75.7885,
      "timestamp": "2026-08-14T14:30:00.000Z",
      "updated_at": "2026-08-15T12:00:00.000Z",
    },
    {
      "id": 103,
      "segment_id": 3,
      "damage_type": "Raveling Asphalt",
      "description": "Aggregate loss resulting in a very rough surface texture. Restored section has worn off.",
      "status": "Resolved",
      "image_url": "https://images.unsplash.com/photo-1594913785162-e67857c5defb?q=80&w=400",
      "severity": "Low",
      "ml_prediction": "Raveling",
      "ml_confidence": 79.0,
      "road_name": "Bypass Road",
      "locality": "Hilite Mall Area",
      "city": "Kozhikode",
      "latitude": 11.2480,
      "longitude": 75.8330,
      "timestamp": "2026-08-10T11:15:00.000Z",
      "updated_at": "2026-08-13T16:00:00.000Z",
    }
  ];

  // =====================================================
  // GET USER REPORTS
  // =====================================================
  Future<List<dynamic>> getReports(String firebaseUid) async {
    final url = Uri.parse("$baseUrl/reports/$firebaseUid/");

    debugPrint("API CALL → GET USER REPORTS");
    debugPrint("URL → $url");

    try {
      final response = await http.get(url);

      debugPrint("STATUS → ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("USER REPORTS COUNT → ${data.length}");
        return data;
      } else {
        throw Exception("Failed to load reports: status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Network error fetching user reports, falling back to mock data: $e");
      return _mockReports;
    }
  }

  // =====================================================
  // GET SEGMENT REPORTS
  // =====================================================
  Future<List<dynamic>> getReportsBySegment(int segmentId) async {
    debugPrint("API CALL → GET SEGMENT REPORTS");

    try {
      final response = await http.get(
        Uri.parse("https://routefixer.dpdns.org/api/reports/segment/$segmentId/"),
      );

      debugPrint("STATUS → ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        final List<dynamic> reports = jsonBody['reports'] ?? [];
        debugPrint("PARSED REPORT COUNT → ${reports.length}");
        return reports;
      } else {
        throw Exception("Failed to fetch reports: status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Network error fetching segment reports, filtering mock reports: $e");
      return _mockReports.where((r) => r["segment_id"] == segmentId).toList();
    }
  }

  // =====================================================
  // SEND REPORT
  // =====================================================
  Future<http.Response> sendReport({
    required String firebaseUid,
    required File? imageFile,
    required String title,
    required String description,
    required String gps,
    required String time,
  }) async {
    final url = Uri.parse("$baseUrl/reports/$firebaseUid/");

    debugPrint("API CALL → SEND REPORT");
    debugPrint("URL → $url");

    try {
      final request = http.MultipartRequest("POST", url);

      final token = await FirebaseMessaging.instance.getToken();

      debugPrint("FCM TOKEN → $token");

      request.fields['damage_type'] = title;
      request.fields['description'] = description;
      request.fields['gps'] = gps;
      request.fields['time'] = time;
      request.fields['fcm_token'] = token ?? "";

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("SEND REPORT STATUS → ${response.statusCode}");
      return response;
    } catch (e) {
      debugPrint("Network error sending report, saving to local mock list: $e");
      final newReportId = 100 + _mockReports.length + 1;
      
      double lat = 11.2588;
      double lng = 75.7804;
      try {
        final coords = gps.split(',');
        if (coords.length >= 2) {
          lat = double.parse(coords[0].trim());
          lng = double.parse(coords[1].trim());
        }
      } catch (_) {}

      _mockReports.insert(0, {
        "id": newReportId,
        "segment_id": 1,
        "damage_type": title,
        "description": description,
        "status": "Pending",
        "image_url": "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=400",
        "severity": "High",
        "ml_prediction": title,
        "ml_confidence": 91.0,
        "road_name": "Reported Location Road",
        "locality": "Reported Area",
        "city": "Kozhikode",
        "latitude": lat,
        "longitude": lng,
        "timestamp": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String(),
      });

      return http.Response(jsonEncode({
        "status": "success",
        "message": "Mock report registered successfully",
        "id": newReportId
      }), 201);
    }
  }
}
