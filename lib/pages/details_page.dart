import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/models/show_models.dart';
import 'package:smollan_tvmaze/providers/favourites_provider.dart';

class DetailsPage extends StatelessWidget {
  final ShowModel show;

  const DetailsPage({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,

            pinned: true,

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: show.id,

                child: CachedNetworkImage(
                  imageUrl: show.image,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.broken_image),
                        SizedBox(height: 10),
                        Center(child: Text("Image can't be loaded")),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          show.name,

                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Consumer<FavouritesProvider>(
                        builder: (context, favoritesprovider, value) {
                          final isFavorite = favoritesprovider.isFavorite(
                            show.id,
                          );
                          return IconButton(
                            onPressed: () {
                              final added = favoritesprovider.toggleFavorite(
                                show,
                              );

                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,

                                  margin: const EdgeInsets.all(16),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),

                                  duration: const Duration(seconds: 1),

                                  content: Text(
                                    added
                                        ? 'Added to favorites'
                                        : 'Removed from favorites',
                                  ),
                                ),
                              );
                            },

                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amberAccent),
                      Text(" ${show.rating}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,

                    children: show.genres.map((genre) {
                      return Chip(label: Text(genre));
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 10),

                  Text(
                    show.cleanSummary,

                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
