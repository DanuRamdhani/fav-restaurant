import 'package:favorite_restaurant/utils/database_helper.dart';
import 'package:favorite_restaurant/models/restaurant_list.dart';
import 'package:flutter/foundation.dart';

enum ResultState { loading, noData, hasData, error }

class DbProvider extends ChangeNotifier {
  late DatabaseHelper _dbHelper;

  List<RestaurantElement> _restaurants = [];
  List<RestaurantElement> get restaurant => _restaurants;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllRest();
  }

  Future<void> _getAllRest() async {
    _state = ResultState.loading;
    notifyListeners();

    _restaurants = await _dbHelper.getRest();
    if (_restaurants.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'No Favorite Restaurant Yet';
    }
    notifyListeners();
  }

  Future<void> addRest(RestaurantElement restaurantElement) async {
    try {
      await _dbHelper.insertRest(restaurantElement);
      _getAllRest();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void deleteRest(String id) async {
    try {
      await _dbHelper.deleteRest(id);
      _getAllRest();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final bookmarkedArticle = await _dbHelper.getRestById(id);
    return bookmarkedArticle.isNotEmpty;
  }
}
