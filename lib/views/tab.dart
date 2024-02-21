import 'package:favorite_restaurant/providers/page.dart';
import 'package:favorite_restaurant/providers/scheduling_provider.dart';
import 'package:favorite_restaurant/utils/notification_helper.dart';
import 'package:favorite_restaurant/views/restaurant_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  static const routeName = '/tab';

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    _notificationHelper.configureSelectNotificationSubject(
      context,
      RestaurantDetailScreen.routeName,
    );
    context.read<SchedulingProvider>().loadIsScheduled();
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          body: pageProvider.pages[pageProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: pageProvider.selectedIndex,
            onTap: (index) => context.read<PageProvider>().onItemTapped(index),
          ),
        );
      },
    );
  }
}
