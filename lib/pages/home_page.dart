import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/pages/details_page.dart';
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
                      final shows = movieProvider.filteredShows;
                      if (movieProvider.homeState == UIState.loading) {
                        return Center(
                          child: Lottie.asset(
                            'assets/lottie/movie_file.json',

                            width: 180,
                          ),
                        );
                      }

                      if (movieProvider.homeState == UIState.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Lottie.asset(
                                'assets/lottie/offline.json',
                                width: 160,
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                "No internet connection",

                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Please check your network\nand try again.",

                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              ElevatedButton(
                                onPressed: () {
                                  context.read<MovieProvider>().fetchShows();
                                },

                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: 45,

                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,

                              itemCount: MovieCategory.values.length,

                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),

                              itemBuilder: (context, index) {
                                final category = MovieCategory.values[index];

                                final isSelected =
                                    movieProvider.selectedCategory == category;

                                return GestureDetector(
                                  onTap: () {
                                    movieProvider.loadCategory(category);
                                  },

                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),

                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : const Color.fromARGB(
                                              255,
                                              97,
                                              96,
                                              96,
                                            ),

                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: Text(category.name.toUpperCase()),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 10),

                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.only(bottom: 70),

                              itemCount: shows.length,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .68,
                                  ),

                              itemBuilder: (context, index) {
                                final show = shows[index];

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

                                      child: show.image.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: show.image,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey.shade800,

                                              child: const Center(
                                                child: Icon(
                                                  Icons.movie,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );

                      // SizedBox(
                      //   height: 45,

                      //   child: ListView.separated(
                      //     scrollDirection: Axis.horizontal,

                      //     itemCount: MovieCategory.values.length,

                      //     separatorBuilder: (_, __) =>
                      //         const SizedBox(width: 10),

                      //     itemBuilder: (context, index) {
                      //       final category = MovieCategory.values[index];

                      //       final isSelected =
                      //           movieProvider.selectedCategory == category;

                      //       return GestureDetector(
                      //         onTap: () {
                      //           movieProvider.loadCategory(category);
                      //         },

                      //         child: Container(
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 16,
                      //             vertical: 10,
                      //           ),

                      //           decoration: BoxDecoration(
                      //             color: isSelected
                      //                 ? Theme.of(context).colorScheme.primary
                      //                 : Colors.grey.shade800,

                      //             borderRadius: BorderRadius.circular(20),
                      //           ),

                      //           child: Text(category.name.toUpperCase()),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // );

                      // return GridView.builder(
                      //   padding: const EdgeInsets.only(bottom: 70),
                      //   itemCount: shows.length,

                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: crossAxisCount,
                      //     crossAxisSpacing: 10,
                      //     mainAxisSpacing: 10,
                      //     childAspectRatio: .68,
                      //   ),

                      //   itemBuilder: (context, index) {
                      //     final show = shows[index];

                      //     return GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (_) => DetailsPage(show: show),
                      //           ),
                      //         );
                      //       },
                      //       child: Hero(
                      //         tag: show.id,
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(12),

                      //           child: show.image.isNotEmpty
                      //               ? CachedNetworkImage(
                      //                   imageUrl: show.image,
                      //                   fit: BoxFit.cover,

                      //                   placeholder: (context, url) {
                      //                     return const Center(
                      //                       child: CircularProgressIndicator(),
                      //                     );
                      //                   },

                      //                   errorWidget: (context, url, error) {
                      //                     return const Icon(Icons.error);
                      //                   },
                      //                 )
                      //               : Container(
                      //                   color: Colors.grey.shade800,

                      //                   child: const Center(
                      //                     child: Icon(Icons.movie, size: 40),
                      //                   ),
                      //                 ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                  );
                },
              ),
            ),
            // SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
