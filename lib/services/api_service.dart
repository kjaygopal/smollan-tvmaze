import 'dart:convert';

import 'package:smollan_tvmaze/models/show_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.tvmaze.com/";
  Future<List<ShowModel>> fetchShows() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/shows'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((item) => ShowModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch shows');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ShowModel>> searchShows(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/shows?q=$query'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((item) => ShowModel.fromJson(item['show'])).toList();
      } else {
        throw Exception('Failed to search shows');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
