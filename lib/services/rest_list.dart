import 'dart:convert';

import 'package:favorite_restaurant/models/restaurant_list.dart';
import 'package:http/http.dart' as http;

class RestLIstService {
  static Future<Restaurant> fetchRest(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://restaurant-api.dicoding.dev/list'));

    return Restaurant.fromJson(jsonDecode(response.body));
  }
}
