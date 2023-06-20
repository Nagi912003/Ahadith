import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:ahadith/data/models/hadith.dart';
import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

import 'package:ahadith/presentation/Screens/favorites_screen/widgets/blurry_background_widget.dart';

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
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 100.w,

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
                      hadithIndex: favoriteItems[index].reference,
                    );
                  },
                )
              : Center(
                  child: Text(
                    'لا يوجد أحاديث مفضلة',
                    style: TextStyle(fontSize: 30.sp, color: Colors.white),
                  ),
                ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () {
                // _showDrawer = true;
                scaffoldKey.currentState!.openDrawer();
                setState(() {});
              },
              icon: Icon(
                Icons.menu,
                size: 35.w,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              onPressed: () {
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linearToEaseOut,
                );
                setState(() {});
              },
              icon: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 35.w,
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
                    '${favoriteItems[index].categories.first} : ${favoriteItems[index].reference}',
                    textAlign: TextAlign.end,
                  ),
                  subtitle: Text(
                    '${favoriteItems[index].title}',
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
  const FavoriteHadith({super.key, required this.hadith, required this.hadithIndex});
  final DetailedHadith hadith;
  final String hadithIndex;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurryBackgroundWidget(hadith: hadith, hadithIndex: hadithIndex),
    );
  }
}

