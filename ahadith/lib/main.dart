import 'package:ahadith/presentation/Screens/home_screen/home_screen.dart';
import 'package:ahadith/theme/theme_constants.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/routes/app_router.dart';

import 'data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';




void main() async{

  // var delegate = await LocalizationDelegate.create(
  //     fallbackLocale: 'en_US',
  //     supportedLocales: ['en_US', 'ar']);

  //init hive
  await Hive.initFlutter();

  //open box favorites
  await Hive.openBox('favorites');
  // await Hive.box('favorites').clear(); // remember random short ahadith
  // print('\n\nopen box favorites--------------------------------------------------------');
  // print('in box favorites>>>>>>>>>>--------${Hive.box('favorites').values}----------------------------------------\n\n');

  //open box saved
  await Hive.openBox('saved');
  // await Hive.box('saved').clear();
  // print('\n\nopen box saved--------------------------------------------------------');
  // print('in box saved>>>>>>>>>>--------${Hive.box('saved').values}----------------------------------------\n\n');


  runApp(const MyApp());

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    // var localizationDelegate = LocalizedApp.of(context).delegate;
    return ScreenUtilInit(
        designSize: const Size(411.42857142857144, 914.2857142857143),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => FavoritesAndSavedProvider(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,

              // localizationsDelegates: [
              //   GlobalMaterialLocalizations.delegate,
              //   GlobalWidgetsLocalizations.delegate,
              //   localizationDelegate
              // ],
              // supportedLocales: localizationDelegate.supportedLocales,
              // locale: localizationDelegate.currentLocale,

              theme: lightTheme,

              darkTheme: darkTheme,

              themeMode: _themeManager.themeMode,

              home: MyHomePage(themeManager: _themeManager),


              /*BlocProvider(
                create: (context) => CategoriesCubit(
                    CategoriesRepository(CategoriesDataProvider())),
                child: const CategoriesScreen(),
              ),*/
              onGenerateRoute: AppRouter().generateRoute,
            ),
          );
        });
  }
}
