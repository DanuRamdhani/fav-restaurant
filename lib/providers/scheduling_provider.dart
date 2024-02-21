import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:favorite_restaurant/utils/background_service.dart';
import 'package:favorite_restaurant/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<void> loadIsScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    final getIsScheduled = prefs.getBool('isScheduled') ?? false;

    _isScheduled = getIsScheduled;
  }

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
