import 'dart:ui';
import 'dart:isolate';
import 'package:favorite_restaurant/main.dart';
import 'package:favorite_restaurant/models/restaurant_list.dart';
import 'package:favorite_restaurant/utils/notification_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper notificationHelper = NotificationHelper();

    final response = await http.get(
      Uri.parse('https://restaurant-api.dicoding.dev/list'),
    );

    if (response.statusCode == 200) {
      final restaurant = Restaurant.fromRawJson(response.body);
      print('restaurant = $restaurant');
      await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin,
        restaurant,
      );
    }

    _uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    _uiSendPort?.send(null);
  }
}
