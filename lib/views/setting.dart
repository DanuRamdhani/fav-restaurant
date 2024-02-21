import 'package:favorite_restaurant/providers/brightness.dart';
import 'package:favorite_restaurant/providers/scheduling_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              children: [
                Material(
                  child: ListTile(
                    title: const Text('Dark Theme'),
                    trailing: Switch.adaptive(
                      value: context.watch<BrightnessProvider>().isDark,
                      onChanged: (_) => setState(() {
                        context.read<BrightnessProvider>().setData();
                      }),
                    ),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: const Text('Scheduling News'),
                    trailing: Consumer<SchedulingProvider>(
                      builder: (context, scheduled, _) {
                        return Switch.adaptive(
                          value: scheduled.isScheduled,
                          onChanged: (value) async {
                            scheduled.scheduledRestaurant(value);

                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('isScheduled', value);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
