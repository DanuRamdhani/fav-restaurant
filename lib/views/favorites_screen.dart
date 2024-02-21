import 'package:favorite_restaurant/providers/db_provider.dart';
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/views/restaurant_detail.dart';
import 'package:favorite_restaurant/widgets/circular_prog_ind_custom.dart';
import 'package:favorite_restaurant/widgets/image_rest.dart';
import 'package:favorite_restaurant/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SearchCustom(autofocus: false),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<DbProvider>(
                  builder: (context, value, child) {
                    if (value.state == ResultState.hasData) {
                      return ListView.builder(
                        itemCount: value.restaurant.length,
                        itemBuilder: (context, index) {
                          final restaurant = value.restaurant[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RestaurantDetailScreen.routeName,
                                  arguments: restaurant,
                                );
                                context
                                    .read<RestDetailProvider>()
                                    .fetchData(restaurant.id);
                              },
                              child: ImageRest(
                                restaurant: restaurant,
                                borderRadius: BorderRadius.circular(8),
                                height: 160,
                                desc: Text(
                                  restaurant.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (value.state == ResultState.noData) {
                      return Center(
                        child: Text(value.message),
                      );
                    }

                    return Center(
                      child: customCircularProgressIndicator(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
