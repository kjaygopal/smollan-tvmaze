import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/pages/details_page.dart';
import 'package:smollan_tvmaze/providers/favourites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const .all(15),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Your Favorites",
                  style: TextStyle(fontSize: 30, fontWeight: .bold),
                ),
              ),
              SizedBox(height: 10),
              Consumer<FavouritesProvider>(
                builder: (context, favoritesprovider, value) {
                  final favorites = favoritesprovider.favorites;
                  if (favorites.isEmpty) {
                    return const Center(child: Text("No favorites yet"));
                  }
                  return Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 2;

                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 6;
                        } else if (constraints.maxWidth > 900) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 3;
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),

                          itemCount: favorites.length,

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: .68,
                              ),

                          itemBuilder: (context, index) {
                            final show = favorites[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) => DetailsPage(show: show),
                                  ),
                                );
                              },

                              child: Hero(
                                tag: show.id,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),

                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: CachedNetworkImage(
                                          imageUrl: show.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Positioned(
                                        top: 8,
                                        right: 8,

                                        child: Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
