import 'package:flutter/material.dart';
import 'package:smollan_tvmaze/models/show_models.dart';
import 'package:smollan_tvmaze/services/api_service.dart';
import 'package:smollan_tvmaze/utils/enums.dart';

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ShowModel> shows = [];
  List<ShowModel> searchResults = [];

  UIState uiState = UIState.loading;

  String errorMessage = '';

  MovieCategory selectedCategory = MovieCategory.trending;

  Future<void> fetchShows() async {
    uiState = UIState.loading;
    notifyListeners();

    try {
      shows = await _apiService.fetchShows();

      uiState = UIState.success;
    } catch (e) {
      errorMessage = e.toString();

      uiState = UIState.error;
    }

    notifyListeners();
  }

  Future<void> searchShows(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    uiState = UIState.loading;
    notifyListeners();

    try {
      searchResults = await _apiService.searchShows(query);

      uiState = UIState.success;
    } catch (e) {
      errorMessage = e.toString();

      uiState = UIState.error;
    }

    notifyListeners();
  }

  void changeCategory(MovieCategory category) {
    selectedCategory = category;

    notifyListeners();
  }
}
