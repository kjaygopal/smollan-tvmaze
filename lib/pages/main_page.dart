import 'package:flutter/material.dart';
import 'package:smollan_tvmaze/pages/favorites_page.dart';
import 'package:smollan_tvmaze/pages/home_page.dart';
import 'package:smollan_tvmaze/pages/search_page.dart';
import 'package:smollan_tvmaze/pages/widgets/floating_bottomnavbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void onNavTap(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _controller,

        children: const [HomePage(), SearchPage(), FavoritesPage()],
      ),

      bottomNavigationBar: FloatingBottomNavBar(
        controller: _controller,
        onTap: onNavTap,
      ),
    );
  }
}
