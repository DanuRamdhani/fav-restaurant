import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_restaurant/models/restaurant_found.dart';

enum ResponseState { initial, loading, succes, fail }

class RestFoundListProvider extends ChangeNotifier {
  RestaurantFound? restaurant;
  String? message;
  ResponseState responseState = ResponseState.initial;

  Future<void> fetchData(String query) async {
    responseState = ResponseState.loading;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/search?q=$query'),
      );

      if (response.statusCode == 200) {
        responseState = ResponseState.succes;
        restaurant = restaurantFoundFromJson(response.body);
        notifyListeners();
      }
    } catch (e) {
      responseState = ResponseState.fail;
      message = 'Failed to load data, No Internet Connections!';
      notifyListeners();
    }
  }
}
