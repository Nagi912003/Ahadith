import 'dart:io';

import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

import '../widgets/blurred_container.dart';
import '../widgets/captured_widget.dart';
import '../widgets/favorite_hadith.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, required this.themeManager});

  final ThemeManager themeManager;
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

  PageController _pageController = PageController(
    initialPage: 0,
  );

  int pageIndex = 0;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
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
                    pageIndex = index;
                    return FavoriteHadith(
                      hadith: favoriteItems[index],
                      hadithIndex: favoriteItems[index].reference,
                      themeManager: widget.themeManager,
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
                color: widget.themeManager.appPrimaryColor200,
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 70,
            child: favoritesCount != 0
                ? IconButton(
                    onPressed: () {
                      _takeScreenshot(favoriteItems[pageIndex],
                          favoriteItems[pageIndex].reference, pixelRatio);
                    },
                    icon: Icon(
                      Icons.share_outlined,
                      size: 35.w,
                      color: widget.themeManager.appPrimaryColor200,
                    ),
                  )
                : Icon(
                    Icons.share_outlined,
                    size: 35.w,
                    color: Colors.grey,
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

  // Future<dynamic> ShowCapturedWidget(
  //     BuildContext context, Uint8List capturedImage) {
  //   return showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       appBar: AppBar(
  //         title: const Text("Captured widget screenshot"),
  //       ),
  //       body: Center(child: Image.memory(capturedImage)),
  //     ),
  //   );
  // }

  void _takeScreenshot(hadith, hadithIndex, pixelRatio) async {
    var takenWidget = Stack(
      children: [
        BlurredContainer(
          child: SizedBox(
            // color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              widget.themeManager.bgImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        CapturedWidget(
          hadith: hadith,
          hadithIndex: hadithIndex,
          context: context,
        ),
      ],
    );
    await screenshotController
        .captureFromWidget(
            // pixelRatio: pixelRatio,
            InheritedTheme.captureAll(context, Material(child: takenWidget)),
            delay: const Duration(seconds: 1))
        .then((image) async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);

      /// Share Plugin
      await Share.shareFiles([imagePath.path], text: '#Ahadith');
      // ShowCapturedWidget(context, image);
    });
  }

  Widget buildDrawer(favoriteItems) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'الأحاديث المفضلة',
              style: TextStyle(fontSize: 30.sp, color: Colors.white),
            ),
          ),
        ),
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
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${favoriteItems[index].title}',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 18.5.sp,
                      ),
                    ),
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
