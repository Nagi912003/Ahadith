import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';

import '../../../constants/strings.dart';
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
            icon: Icon(Icons.list_alt),
            label: 'موسوعة الأحاديث',
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
          ListTile(
            title: Text(
              'اللغة',
              style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
            // trailing: DropdownButton<String>(
            //   value: widget.themeManager.currentLanguage,
            //   icon: const Icon(Icons.arrow_downward),
            //   iconSize: 24,
            //   elevation: 16,
            //   style: TextStyle(
            //     fontSize: 20.sp,
            //     color: Theme.of(context).textTheme.bodySmall!.color,
            //   ),
            //   underline: Container(
            //     height: 2,
            //     color: Theme.of(context).textTheme.bodySmall!.color,
            //   ),
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       widget.themeManager.currentLanguage = newValue!;
            //     });
            //   },
            //   items: <String>['العربية', 'English']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(
            //         value == 'العربية' ? 'العربية' : 'English',
            //         style: TextStyle(
            //           fontSize: 20.sp,
            //           color: Theme.of(context).textTheme.bodySmall!.color,
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
          ),
          ListTile(
            title: Text(
              'المظهر',
              style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
            trailing: DropdownButton<ThemeMode>(
              items: [
                DropdownMenuItem(
                  child: Text(
                    'الوضع الافتراضي',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  value: ThemeMode.system,
                ),
                DropdownMenuItem(
                  child: Text(
                    'الوضع الفاتح',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  value: ThemeMode.light,
                ),
                DropdownMenuItem(
                  child: Text(
                    'الوضع الداكن',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  value: ThemeMode.dark,
                ),
              ],
              value: widget.themeManager.themeMode,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
              underline: Container(
                height: 2,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
              onChanged: (ThemeMode? newValue) {
                setState(() {
                  widget.themeManager.themeMode = newValue!;
                });
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHomePageGrid() {
    return Stack(
      children: [

        Align(
          alignment: const Alignment(0, 0),
          child: Container(
            width: 0.9.sw,
            height: 0.2.sh,
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'وما ينطق عن الهوى ان هوا الا وحي يوحى',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
