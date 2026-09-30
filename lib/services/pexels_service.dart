import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/photo.dart';

class PexelsService {
  static const String apiKey =
    String.fromEnvironment('PEXELS_API_KEY');

  Future<List<Photo>> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://api.pexels.com/v1/curated?page=$page&per_page=$perPage',
      ),
      headers: {
        'Authorization': apiKey,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load photos');
    }

    final data = jsonDecode(response.body);

    final List photosJson = data['photos'];

    return photosJson
        .map((photoJson) => Photo.fromJson(photoJson))
        .toList();
  }

  Future<List<Photo>> searchPhotos({
  required String query,
  int page = 1,
  int perPage = 20,
}) async {
  final response = await http.get(
     Uri.parse(
      'https://api.pexels.com/v1/search'
      '?query=${Uri.encodeComponent(query)}'
      '&page=$page'
      '&per_page=$perPage',
    ),
    headers: {
      'Authorization': apiKey,
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to search photos');
  }

  final data = jsonDecode(response.body);

  final List photosJson = data['photos'];

  return photosJson
      .map((photoJson) => Photo.fromJson(photoJson))
      .toList();
}
}