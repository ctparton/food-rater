import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleLocationService {
  final String kPLACES_API_KEY = env['G_KEY'];
  final String BASE_URL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  Future<List<dynamic>> getPlaceAutocomplete(
      String query, String sessionToken) async {
    String request =
        '$BASE_URL?input=$query&key=$kPLACES_API_KEY&sessiontoken=$sessionToken';
    var response = await http.get(request);
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
