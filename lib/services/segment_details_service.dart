import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/segment_details.dart';

class SegmentDetailsService {
  final String baseUrl = "https://routefixer.dpdns.org/api";

  Future<SegmentDetails> fetchDetails(int segmentId) async {
    final url = Uri.parse("$baseUrl/segments/$segmentId/details/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return SegmentDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load segment details");
      }
    } catch (e) {
      print("Network error fetching segment details, falling back to mock details: $e");
      String severity = "low";
      if (segmentId == 1) severity = "high";
      if (segmentId == 2) severity = "medium";
      
      return SegmentDetails(
        id: segmentId,
        totalReports: segmentId == 1 ? 5 : (segmentId == 2 ? 3 : 1),
        maxSeverity: severity.toUpperCase(),
        lastReportDate: DateTime.now().subtract(Duration(hours: segmentId * 4)),
        avgSeverityScore: segmentId == 1 ? 4.5 : (segmentId == 2 ? 3.0 : 1.5),
      );
    }
  }
}
