import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:favorite_restaurant/models/restaurant_detail.dart';
import 'package:http/http.dart' as http;
import 'package:favorite_restaurant/providers/restaurant_detail.dart';
import 'package:favorite_restaurant/widgets/add_review.dart';

class RestDetailItem extends StatefulWidget {
  const RestDetailItem({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<RestDetailItem> createState() => _RestDetailItemState();
}

class _RestDetailItemState extends State<RestDetailItem> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController reviewCtrl = TextEditingController();

  Future<void> _sendReview() async {
    if (nameCtrl.text.isEmpty && reviewCtrl.text.isEmpty) {
      return;
    }

    try {
      final url = Uri.parse('https://restaurant-api.dicoding.dev/review');
      final restProvider =
          Provider.of<RestDetailProvider>(context, listen: false);

      final id = restProvider.restaurant!.restaurant.id;

      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": id,
          "name": nameCtrl.text,
          "review": reviewCtrl.text,
        }),
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Send review succes'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
      context.read<RestDetailProvider>().fetchData(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Send review failed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.restaurant.address,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Description :',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            widget.restaurant.description,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            'Categories :',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.restaurant.categories.length,
              itemBuilder: (context, index) {
                final food = widget.restaurant.menus.foods[index];
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onBackground,
                    ),
                    child: Text(food.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Menus :',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.restaurant.menus.foods.length,
              itemBuilder: (context, index) {
                final food = widget.restaurant.menus.foods[index];
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onBackground,
                    ),
                    child: Text(food.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: widget.restaurant.menus.drinks.length,
              itemBuilder: (context, index) {
                final drink = widget.restaurant.menus.drinks[index];
                return Container(
                  margin: const EdgeInsets.all(2),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onBackground,
                    ),
                    child: Text(drink.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews :',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton.icon(
                onPressed: () =>
                    showAddReview(context, nameCtrl, reviewCtrl, _sendReview),
                icon: const Icon(Icons.add),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onBackground,
                ),
                label: const Text('Add Review'),
              ),
            ],
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: widget.restaurant.customerReviews.length,
              itemBuilder: (context, index) {
                final review = widget.restaurant.customerReviews[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      review.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.review,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          review.date.toString(),
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: theme.colorScheme.onBackground
                                        .withOpacity(0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
