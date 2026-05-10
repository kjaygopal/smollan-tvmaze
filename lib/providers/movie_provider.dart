import 'package:flutter/material.dart';
import 'package:smollan_tvmaze/models/show_models.dart';
import 'package:smollan_tvmaze/services/api_service.dart';
import 'package:smollan_tvmaze/utils/enums.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ShowModel> shows = [];
  List<ShowModel> searchResults = [];

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

  // Future<void> searchShows(String query) async {
  //   if (query.isEmpty) {
  //     searchResults = [];
  //     notifyListeners();
  //     return;
  //   }

  //   searchState = UIState.loading;
  //   notifyListeners();

  //   try {
  //     searchResults = await _apiService.searchShows(query);

  //     searchState = UIState.success;
  //   } catch (e) {
  //     errorMessage = e.toString();

  //     searchState = UIState.error;
  //   }

  //   notifyListeners();
  // }

  void changeCategory(MovieCategory category) {
    selectedCategory = category;

    notifyListeners();
  }
}
