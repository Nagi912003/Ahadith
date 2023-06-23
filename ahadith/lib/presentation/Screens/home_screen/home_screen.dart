import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../data/data_providers/categories_data_provider.dart';
import '../../../data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import '../../../data/repositories/categories_repository.dart';

import '../../../business_logic/categories_cubit/categories_cubit.dart';

import '../categories_screen/UI/categories_screen.dart';
import '../favorites_screen/UI/favorites_screens.dart';
import '../favorites_screen/widgets/blurred_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void didChangeDependencies() {
    // Provider.of<FavoritesAndSavedProvider>(context).clearFavorites();
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
  String text = '{widget.hadith.hadeeth!}wwii,{widget.hadith.hadeeth!}wwii,,,{widget.hadith.hadeeth!}wwii,{widget.hadith.hadeeth!}wwii,,';
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
                'assets/images/watercolor.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              MultiProvider(
                providers: [
                  ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                    value: Provider.of<FavoritesAndSavedProvider>(context),
                  ),
                ],
                child: const FavoritesScreen(),
              ),
              BlocProvider(
                create: (context) => CategoriesCubit(
                    CategoriesRepository(CategoriesDataProvider())),
                child: const CategoriesScreen(),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        //backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الصفحة الرئيسية',
          ),
        ],
      ),
    );
  }

}
