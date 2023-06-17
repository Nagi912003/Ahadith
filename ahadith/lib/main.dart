import 'package:ahadith/presentation/Screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_router.dart';

import 'data/data_providers/categories_data_provider.dart';
import 'data/repositories/categories_repository.dart';
import 'data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

import 'business_logic/categories_cubit/categories_cubit.dart';

import 'presentation/Screens/categories_screen/UI/categories_screen.dart';



void main() {
  // // Set the system UI overlay style
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // Make the status bar transparent
  //   statusBarBrightness: Brightness.dark, // Dark text for status bar icons
  // ));
  // Set the system UI overlay mode
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  // const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent, // Make the status bar transparent
  //   statusBarBrightness: Brightness.dark, // Dark text for status bar icons
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
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
