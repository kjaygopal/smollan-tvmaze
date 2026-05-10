import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:smollan_tvmaze/pages/main_page.dart';
import 'package:smollan_tvmaze/providers/favourites_provider.dart';
import 'package:smollan_tvmaze/providers/movie_provider.dart';
import 'package:smollan_tvmaze/providers/theme_provider.dart';
import 'package:smollan_tvmaze/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),

        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Smollan TvMaze",
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.currentTheme,
            home: MainPage(),
          );
        },
      ),
    );
  }
}
