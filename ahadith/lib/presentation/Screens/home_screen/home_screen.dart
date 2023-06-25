import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
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
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  final _today = HijriCalendar.now();

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
                'assets/images/watercolor.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView(
            // physics: const NeverScrollableScrollPhysics(),

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
              _buildHomePageGrid(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'موسوعة الأحاديث',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePageGrid() {
    return Stack(
      children: [


        // Positioned(
        //   bottom: 0,
        //   left: 10,
        //   right: 10,
        //   child: Container(
        //     width: 1.sw,
        //     height: 0.22.sh,
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).cardColor,
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(30),
        //         topRight: Radius.circular(30),
        //       ),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: const Alignment(0.9, -0.9),
        //   child: Text(
        //     _today.toFormat("MMMM dd yyyy"),
        //     style: TextStyle(
        //       fontSize: 18.sp,
        //       color: Theme.of(context).textTheme.bodySmall!.color,
        //     ),
        //   ),
        // ),
        Align(
          alignment: const Alignment(0, -0.8),
          child: Container(
            width: 0.9.sw,
            height: 0.2.sh,
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'اللهم صل على محمد',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.8),
          child: Container(
            width: 0.9.sw,
            height: 0.2.sh,
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'وما ينطق عن الهوى ان هوا الا وحي يوحى',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ),
        ),
        // Align(
        //   alignment: const Alignment(0, 0.85),
        //   child: Padding(
        //     padding: const EdgeInsets.all(18.0),
        //     child: GridView(
        //       shrinkWrap: true,
        //       physics: const BouncingScrollPhysics(),
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         childAspectRatio: 2,
        //         crossAxisSpacing: 10,
        //         mainAxisSpacing: 10,
        //       ),
        //       children: [
        //         InkWell(
        //           onTap: () {
        //             setState(() {
        //               _onNavItemTapped(0);
        //               _currentIndex = 0;
        //             });
        //           },
        //           child: Card(
        //             child: Center(
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text('المفضلة', style: TextStyle(fontSize: 18.sp, color: Theme.of(context).textTheme.bodySmall!.color,)),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   Icon(Icons.favorite_rounded, color: Theme.of(context).textTheme.bodySmall!.color,),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         InkWell(
        //           onTap: () {
        //             setState(() {
        //               _onNavItemTapped(2);
        //               _currentIndex = 2;
        //             });
        //           },
        //           child: Card(
        //             child: Center(
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Text('موسوعة الأحاديث', style: TextStyle(fontSize: 18.sp, color: Theme.of(context).textTheme.bodySmall!.color,)),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   Icon(Icons.list_alt, color: Theme.of(context).textTheme.bodySmall!.color,),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),


      ],
    );
  }
}
