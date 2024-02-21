import 'package:favorite_restaurant/views/favorites_screen.dart';
import 'package:favorite_restaurant/views/restaurant_list.dart';
import 'package:favorite_restaurant/views/setting.dart';
import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  int selectedIndex = 0;

  final List pages = [
    const RestaurantListScreen(),
    const FavoritesScreen(),
    const SettingScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
