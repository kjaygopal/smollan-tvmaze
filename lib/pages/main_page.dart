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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: _controller,

            children: const [HomePage(), SearchPage(), FavoritesPage()],
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 20,

            child: FloatingBottomNavBar(
              controller: _controller,
              onTap: onNavTap,
            ),
          ),
        ],
      ),

      // bottomNavigationBar: FloatingBottomNavBar(
      //   controller: _controller,
      //   onTap: onNavTap,
      // ),
    );
  }
}
