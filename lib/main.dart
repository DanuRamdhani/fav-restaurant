import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:favorite_restaurant/common/navigation.dart';
import 'package:favorite_restaurant/providers/brightness.dart';
import 'package:favorite_restaurant/providers/db_provider.dart';
import 'package:favorite_restaurant/providers/page.dart';
import 'package:favorite_restaurant/providers/scheduling_provider.dart';
import 'package:favorite_restaurant/utils/background_service.dart';
import 'package:favorite_restaurant/utils/notification_helper.dart';
import 'package:favorite_restaurant/views/tab.dart';
import 'package:flutter/material.dart';
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/providers/restaurant_found_list.dart';
import 'package:favorite_restaurant/providers/restaurant_list.dart';
import 'package:favorite_restaurant/views/restaurant_detail.dart';
import 'package:favorite_restaurant/views/restaurant_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/views/search_screen.dart';
import 'package:favorite_restaurant/views/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestListProvider()),
        ChangeNotifierProvider(create: (_) => RestDetailProvider()),
        ChangeNotifierProvider(create: (_) => RestFoundListProvider()),
        ChangeNotifierProvider(
          create: (_) => DbProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => BrightnessProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<BrightnessProvider>(context).isDark;
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: isDark ? Brightness.dark : Brightness.light,
          seedColor: Colors.indigo,
          primary: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        RestaurantListScreen.routeName: (_) => const RestaurantListScreen(),
        RestaurantDetailScreen.routeName: (context) => RestaurantDetailScreen(
            restaurantList:
                ModalRoute.of(context)?.settings.arguments as dynamic),
        SearchScreen.routeName: (_) => const SearchScreen(),
        TabScreen.routeName: (_) => const TabScreen(),
      },
    );
  }
}
