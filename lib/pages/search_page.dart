import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/pages/details_page.dart';
import 'dart:async';

import 'package:smollan_tvmaze/providers/movie_provider.dart';
import 'package:smollan_tvmaze/utils/enums.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MovieProvider>().searchShows(searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 30, fontWeight: .bold),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: searchController.text.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () => searchController.clear(),
                          icon: Icon(Icons.close),
                        ),
                  hint: Text("Search shows, movies etc.."),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<MovieProvider>(
                  builder: (context, movieProvider, child) {
                    if (movieProvider.searchState == UIState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (movieProvider.searchState == UIState.error) {
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
                          ],
                        ),
                      );
                    }
                    if (searchController.text.trim().isEmpty) {
                      return const Center(
                        child: Text("Search your favorite shows, movies"),
                      );
                    }

                    if (movieProvider.searchResults.isEmpty &&
                        searchController.text.trim().isNotEmpty) {
                      return const Center(child: Text("No shows found"));
                    }

                    final shows = movieProvider.searchResults;

                    return ListView.builder(
                      itemCount: shows.length,

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
                            child: Material(
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),

                                  child: show.image.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: show.image,
                                          width: 50,
                                          fit: BoxFit.cover,

                                          placeholder: (context, url) {
                                            return const Center(child: null);
                                          },

                                          errorWidget: (context, url, error) {
                                            return const Icon(Icons.error);
                                          },
                                        )
                                      : Container(
                                          width: 50,
                                          color: Colors.grey.shade800,

                                          child: const Icon(Icons.movie),
                                        ),
                                ),

                                title: Text(show.name),

                                subtitle: Text(show.genres.join(', ')),
                              ),
                            ),
                          ),
                        );
                      },
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
