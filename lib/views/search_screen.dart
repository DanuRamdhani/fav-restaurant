import 'package:favorite_restaurant/views/restaurant_detail.dart';
import 'package:favorite_restaurant/widgets/circular_prog_ind_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/providers/restaurant_found_list.dart';
import 'package:favorite_restaurant/widgets/image_rest.dart';
import 'package:favorite_restaurant/widgets/search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _performSearch() {
    String query = _searchController.text.trim();

    FocusScope.of(context).unfocus();
    context.read<RestFoundListProvider>().fetchData(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Search Restaurant'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchCustom(
                searchController: _searchController,
                performSearch: _performSearch,
                autofocus: true,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Consumer<RestFoundListProvider>(
                  builder: (context, value, child) {
                    if (value.restaurant?.founded == 0) {
                      return Center(
                        child: Text(
                          'Restaurant not found',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }

                    if (value.responseState == ResponseState.fail) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value.message.toString(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () => context
                                .read<RestFoundListProvider>()
                                .fetchData(_searchController.text),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      );
                    }

                    if (value.responseState == ResponseState.succes) {
                      return ListView.builder(
                        itemCount: value.restaurant!.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant =
                              value.restaurant!.restaurants[index];
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
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (value.responseState == ResponseState.initial) {
                      return Center(
                        child: Text(
                          'Search any restaurant',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color:
                                theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
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
