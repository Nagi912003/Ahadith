import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../data/data_providers/categories_data_provider.dart';
import '../../../data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import '../../../data/repositories/categories_repository.dart';

import '../../../business_logic/categories_cubit/categories_cubit.dart';

import '../../../theme/theme_manager.dart';
import '../categories_screen/UI/categories_screen.dart';
import '../favorites_screen/UI/favorites_screens.dart';
import '../favorites_screen/widgets/blurred_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.themeManager});

  final ThemeManager themeManager;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    Provider.of<FavoritesAndSavedProvider>(context, listen: false)
        .buildInvertedIndex();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<FavoritesAndSavedProvider>(context).fitchFavorites();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int textLength = 160;

  @override
  Widget build(BuildContext context) {
    String text =
        'اللهم صل على محمد وعلى آل محمد كما صليت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد اللهم بارك على محمد وعلى آل محمد كما باركت على إبراهيم وعلى آل إبراهيم إنك حميد مجيد';
    textLength = text.length;
    return Scaffold(
      body: Stack(
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
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              MultiProvider(
                providers: [
                  ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                    value: Provider.of<FavoritesAndSavedProvider>(context),
                  ),
                ],
                child: FavoritesScreen(themeManager: widget.themeManager),
              ),
              BlocProvider(
                create: (context) => CategoriesCubit(
                    CategoriesRepository(CategoriesDataProvider())),
                child: CategoriesScreen(themeManager: widget.themeManager),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        currentIndex: _currentIndex,
        selectedItemColor: widget.themeManager.appPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'موسوعة الأحاديث',
          ),
        ],
      ),
    );
  }
}
