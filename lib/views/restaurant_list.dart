import 'package:favorite_restaurant/providers/brightness.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/providers/restaurant_list.dart';
import 'package:favorite_restaurant/widgets/rest_list_item.dart';
import 'package:favorite_restaurant/widgets/search.dart';
import 'package:favorite_restaurant/widgets/title_rest_list.dart';
import 'package:http/http.dart' as http;

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  static const routeName = '/restaurant_list';

  @override
  State<RestaurantListScreen> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantListScreen> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<RestListProvider>().fetchData(http.Client());
    context.read<BrightnessProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<RestListProvider>().fetchData(http.Client()),
            backgroundColor: theme.colorScheme.onBackground,
            color: theme.colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const TitleRestList(),
                const SizedBox(height: 40),
                SearchCustom(
                  onTap: () {
                    Navigator.of(context).pushNamed('/search');
                    _focusNode.unfocus();
                  },
                  autofocus: false,
                  focusNode: _focusNode,
                ),
                const SizedBox(height: 16),
                const RestListItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
