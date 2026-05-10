import 'package:flutter/material.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
