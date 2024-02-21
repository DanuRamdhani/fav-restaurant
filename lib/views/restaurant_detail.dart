import 'package:favorite_restaurant/providers/db_provider.dart';
import 'package:favorite_restaurant/widgets/circular_prog_ind_custom.dart';
import 'package:flutter/material.dart';
import 'package:favorite_restaurant/models/restaurant_list.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/widgets/image_rest.dart';
import 'package:favorite_restaurant/widgets/rest_detail_item.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantList});

  static const routeName = '/restaurant_detail';

  final dynamic restaurantList;

  void addDeleteFavorite(BuildContext context, bool isFavorite) {
    final restaurantElement = RestaurantElement(
      id: restaurantList.id,
      name: restaurantList.name,
      description: restaurantList.description,
      pictureId: restaurantList.pictureId,
      city: restaurantList.city,
      rating: restaurantList.rating,
    );

    if (isFavorite == false) {
      context.read<DbProvider>().addRest(restaurantElement);
    } else if (isFavorite == true) {
      context.read<DbProvider>().deleteRest(restaurantList.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ImageRest(
                    restaurant: restaurantList,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Consumer<DbProvider>(
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: value.isFavorite(restaurantList.id),
                        builder: (context, snapshot) {
                          return Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () => addDeleteFavorite(
                                  context, snapshot.data ?? false),
                              icon: snapshot.data ?? false
                                  ? const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.redAccent,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_rounded,
                                      color: Colors.white,
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Consumer<RestDetailProvider>(
                builder: (context, value, child) {
                  final restaurant = value.restaurant?.restaurant;

                  if (value.responseState == ResponseStateDetail.fail) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value.message.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.6),
                                    fontSize: 18,
                                  ),
                            ),
                            IconButton(
                              onPressed: () => context
                                  .read<RestDetailProvider>()
                                  .fetchData(restaurantList.id),
                              icon: const Icon(Icons.refresh),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (value.responseState == ResponseStateDetail.succes) {
                    return RestDetailItem(restaurant: restaurant!);
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child:
                        Center(child: customCircularProgressIndicator(context)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
