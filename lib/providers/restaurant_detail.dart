import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_restaurant/models/restaurant_detail.dart';

enum ResponseStateDetail { initial, loading, succes, fail }

class RestDetailProvider extends ChangeNotifier {
  RestaurantDetail? restaurant;
  String? message;
  ResponseStateDetail responseState = ResponseStateDetail.initial;

  Future<void> fetchData(String id) async {
    responseState = ResponseStateDetail.loading;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'),
      );

      if (response.statusCode == 200) {
        responseState = ResponseStateDetail.succes;
        restaurant = restaurantDetailFromJson(response.body);
        notifyListeners();
      }
    } catch (e) {
      responseState = ResponseStateDetail.fail;
      message = 'Failed to load data, No Internet Connections!';
      notifyListeners();
    }
  }
}
