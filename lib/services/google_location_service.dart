import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class to handle all interactions with Google Places Autocomplete
///
/// This class currently handles returning the decoded json response to the
/// caller
class GoogleLocationService {
  final String kPLACES_API_KEY = env['G_KEY'];
  final String BASE_URL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  /// Returns the decoded predictions list from the places autocomplete if the
  /// [sessionToken] is valid and the [query] is valid
  Future<List<dynamic>> getPlaceAutocomplete(
      String query, String sessionToken) async {
    print(sessionToken);
    String request =
        '$BASE_URL?input=$query&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';
    var response = await http.get(request);
    if (response.statusCode == 200) {
      return json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
