import 'package:flutter/material.dart';

class ImageRest extends StatelessWidget {
  const ImageRest({
    super.key,
    required this.restaurant,
    required this.borderRadius,
    required this.height,
    this.desc,
  });

  final dynamic restaurant;
  final BorderRadius borderRadius;
  final double height;
  final Text? desc;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: restaurant.id,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
                Color.fromARGB(80, 0, 0, 0), BlendMode.darken),
            image: NetworkImage(
              'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                restaurant.name,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              desc ?? const SizedBox(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  Text(
                    restaurant.city,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star_rate_rounded,
                    color: Colors.yellowAccent,
                  ),
                  Text(
                    restaurant.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
