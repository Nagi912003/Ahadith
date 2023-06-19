import 'package:ahadith/data/models/hadith.dart';
import 'package:ahadith/presentation/Screens/favorites_screen/widgets/blurry_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<FavoritesAndSavedProvider>(context).fitchFavorites();
    super.didChangeDependencies();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesAndSavedProvider>(context);
    final favoriteItems = favoritesProvider.favoriteItems;
    final favoritesCount = favoritesProvider.favoriteCount;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          favoritesCount != 0
              ? PageView.builder(
            physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: favoritesCount,
                  itemBuilder: (context, index) {
                    return FavoriteHadith(
                      hadith: favoriteItems[index],
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'لا يوجد أحاديث مفضلة',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
          Align(
            alignment: const Alignment(-0.9, -0.9),
            child: IconButton(
              onPressed: () {
                // _showDrawer = true;
                scaffoldKey.currentState!.openDrawer();
                setState(() {});
              },
              icon: const Icon(
                Icons.menu,
                size: 35,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 0.9),
            child: IconButton(
              onPressed: () {
                print(
                    'in the box favorites after toggle favorites--->>${Hive.box('favorites').values}');
                setState(() {});
              },
              icon: const Icon(
                Icons.show_chart,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: buildDrawer(favoriteItems),
      ),
    );
  }

  Widget buildDrawer(favoriteItems) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'الأحاديث المفضلة',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 50,
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    '${favoriteItems[index].categories.first}',
                    textAlign: TextAlign.end,
                  ),
                  subtitle: Text(
                    '${favoriteItems[index].hadeeth}',
                    textAlign: TextAlign.end,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linearToEaseOut,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FavoriteHadith extends StatelessWidget {
  const FavoriteHadith({super.key, required this.hadith});
  final DetailedHadith hadith;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurryBackgroundWidget(hadith: hadith),
    );
  }
}
