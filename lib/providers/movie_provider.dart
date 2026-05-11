import 'package:flutter/material.dart';
import 'package:smollan_tvmaze/models/show_models.dart';
import 'package:smollan_tvmaze/services/api_service.dart';
import 'package:smollan_tvmaze/utils/enums.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ShowModel> shows = [];
  List<ShowModel> searchResults = [];
  List<ShowModel> filteredShows = [];

  // UIState uiState = UIState.loading;
  UIState homeState = UIState.loading;

  UIState searchState = UIState.success;

  String errorMessage = '';

  MovieCategory selectedCategory = MovieCategory.trending;

  Future<void> fetchShows() async {
    if (shows.isNotEmpty) return;
    homeState = UIState.loading;
    notifyListeners();

    try {
      shows = await _apiService.fetchShows();

      filteredShows = shows.take(30).toList();

      homeState = UIState.success;
    } catch (e) {
      errorMessage = e.toString();

      homeState = UIState.error;
    }

    notifyListeners();
  }

  String lastQuery = '';

  Future<void> searchShows(String query) async {
    query = query.trim();

    if (query.isEmpty) {
      searchResults = [];

      searchState = UIState.success;

      notifyListeners();

      return;
    }

    if (query == lastQuery) return;

    lastQuery = query;

    try {
      searchState = UIState.loading;

      notifyListeners();

      searchResults = await _apiService.searchShows(query);

      searchState = UIState.success;
    } catch (e) {
      errorMessage = e.toString();

      searchState = UIState.error;
    }

    notifyListeners();
  }

  void loadCategory(MovieCategory category) {
    selectedCategory = category;

    switch (category) {
      case MovieCategory.trending:
        filteredShows = shows.take(30).toList();

        break;

      case MovieCategory.popular:
        final popular = [...shows];

        popular.sort((a, b) => b.weight.compareTo(a.weight));

        filteredShows = popular.take(30).toList();

        break;

      case MovieCategory.upcoming:
        final upcoming = [...shows];

        upcoming.sort((a, b) => b.id.compareTo(a.id));

        filteredShows = upcoming.take(30).toList();

        break;
    }

    notifyListeners();
  }
}
