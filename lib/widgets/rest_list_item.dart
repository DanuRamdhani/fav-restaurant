import 'package:favorite_restaurant/views/restaurant_detail.dart';
import 'package:favorite_restaurant/widgets/circular_prog_ind_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/providers/restaurant_list.dart';
import 'package:favorite_restaurant/widgets/image_rest.dart';
import 'package:http/http.dart' as http;

class RestListItem extends StatefulWidget {
  const RestListItem({super.key});

  @override
  State<RestListItem> createState() => _RestListItemState();
}

class _RestListItemState extends State<RestListItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Consumer<RestListProvider>(
        builder: (context, value, child) {
          if (value.responseState == ResponseState.fail) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value.message.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                        fontSize: 18,
                      ),
                ),
                IconButton(
                  onPressed: () =>
                      context.read<RestListProvider>().fetchData(http.Client()),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            );
          }

          if (value.responseState == ResponseState.succes) {
            return ListView.builder(
              itemCount: value.restaurant!.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = value.restaurant!.restaurants[index];
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: customCircularProgressIndicator(context));
        },
      ),
    );
  }
}
