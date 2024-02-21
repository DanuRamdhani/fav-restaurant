import 'package:favorite_restaurant/services/rest_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_restaurant/models/restaurant_list.dart';

enum ResponseState { initial, loading, succes, fail }

class RestListProvider extends ChangeNotifier {
  Restaurant? restaurant;
  String? message;
  ResponseState responseState = ResponseState.initial;

  Future<void> fetchData(http.Client client) async {
    responseState = ResponseState.loading;

    try {
      restaurant = await RestLIstService.fetchRest(client);
      responseState = ResponseState.succes;
      notifyListeners();
    } catch (e) {
      responseState = ResponseState.fail;
      message = 'Failed to load data, No Internet Connections!';
      notifyListeners();
    }
  }
}
