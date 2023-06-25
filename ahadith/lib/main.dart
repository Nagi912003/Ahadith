import 'package:ahadith/presentation/Screens/home_screen/home_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

              theme: ThemeData(
                brightness: Brightness.light,
                //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,

                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  // titleTextStyle: GoogleFonts.gulzar(
                  //   color: Colors.black87,
                  //   fontSize: 20.sp,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  titleTextStyle: GoogleFonts.kufam(
                    color: Colors.black87,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                textTheme: TextTheme(
                  bodyLarge: GoogleFonts.kufam(
                    color: Colors.black87,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyMedium: GoogleFonts.kufam(
                    color: Colors.black87,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  bodySmall: GoogleFonts.kufam(
                    color: Colors.black87,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  titleLarge: GoogleFonts.kufam(
                    color: Colors.black87,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  displaySmall: GoogleFonts.lateef(
                    color: Colors.black87,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // textTheme: TextTheme(
                //   bodyLarge: GoogleFonts.gulzar(
                //     color: Colors.black87,
                //     fontSize: 18.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   bodyMedium: GoogleFonts.gulzar(
                //     color: Colors.black87,
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   bodySmall: GoogleFonts.amiri(
                //     color: Colors.black87,
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   titleLarge: GoogleFonts.rakkas(
                //     color: Colors.black87,
                //     fontSize: 25.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),

                cardTheme: const CardTheme(
                  shadowColor: Colors.black,
                  elevation: 0,
                ),
                cardColor: Colors.grey[100],
              ),

              darkTheme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.black12,
                  foregroundColor: Colors.deepPurple.shade100,
                  titleTextStyle: GoogleFonts.kufam(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  // titleTextStyle: GoogleFonts.gulzar(
                  //   color: Colors.white,
                  //   fontSize: 20.sp,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),

                textTheme: TextTheme(
                  bodyLarge: GoogleFonts.kufam(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  bodyMedium: GoogleFonts.gulzar(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  bodySmall: GoogleFonts.amiri(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  titleLarge: GoogleFonts.rakkas(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  displaySmall: GoogleFonts.lateef(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // textTheme: TextTheme(
                //   bodyLarge: GoogleFonts.gulzar(
                //     color: Colors.white,
                //     fontSize: 18.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   bodyMedium: GoogleFonts.gulzar(
                //     color: Colors.white,
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   bodySmall: GoogleFonts.amiri(
                //     color: Colors.white,
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   titleLarge: GoogleFonts.rakkas(
                //     color: Colors.white,
                //     fontSize: 25.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),

                cardTheme: const CardTheme(
                  shadowColor: Colors.white,
                  elevation: 0,
                ),
                cardColor: Colors.black45,
              ),

              themeMode: ThemeMode.system,

              home: const MyHomePage(),


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
