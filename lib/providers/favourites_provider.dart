import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smollan_tvmaze/models/show_models.dart';

class FavouritesProvider extends ChangeNotifier {
  final Box box = Hive.box('favorites');

  List<ShowModel> favorites = [];

  FavouritesProvider() {
    loadFavorites();
  }

  void loadFavorites() {
    favorites = box.values
        .map((e) => ShowModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    notifyListeners();
  }

  bool isFavorite(int showId) {
    return box.containsKey(showId);
  }

  bool toggleFavorite(ShowModel show) {
    final exists = favorites.any((item) => item.id == show.id);

    bool added;

    if (exists) {
      favorites.removeWhere((item) => item.id == show.id);

      box.delete(show.id);

      added = false;
    } else {
      favorites.add(show);

      box.put(show.id, show.toMap());

      added = true;
    }

    notifyListeners();

    return added;
  }
}
