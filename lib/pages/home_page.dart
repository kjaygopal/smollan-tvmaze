import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/providers/movie_provider.dart';
import 'package:smollan_tvmaze/providers/theme_provider.dart';
import 'package:smollan_tvmaze/utils/enums.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "Movie Verse",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                onPressed: () {
                  themeProvider.toggleTheme();
                },

                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Trending shows"),
            ),
            SizedBox(height: 10),
            Expanded(
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

                  return Consumer<MovieProvider>(
                    builder: (context, movieProvider, value) {
                      final shows = movieProvider.shows.take(30).toList();
                      if (movieProvider.homeState == UIState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (movieProvider.homeState == UIState.error) {
                        return Center(child: Text(movieProvider.errorMessage));
                      }

                      return GridView.builder(
                        itemCount: shows.length,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: .68,
                        ),

                        itemBuilder: (context, index) {
                          final show = shows[index];

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),

                            child: show.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: show.image,
                                    fit: BoxFit.cover,

                                    placeholder: (context, url) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },

                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Container(
                                    color: Colors.grey.shade800,

                                    child: const Center(
                                      child: Icon(Icons.movie, size: 40),
                                    ),
                                  ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
