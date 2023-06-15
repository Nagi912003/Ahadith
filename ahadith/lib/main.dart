import 'package:ahadith/business_logic/categories_cubit/categories_cubit.dart';
import 'package:ahadith/data/data_providers/categories_data_provider.dart';
import 'package:ahadith/data/repositories/categories_repository.dart';
import 'package:ahadith/presentation/Screens/categories_screen/UI/categories_screen.dart';
import 'package:flutter/material.dart';

import 'package:ahadith/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(screenSize.width);
    print(screenSize.height);
    return ScreenUtilInit(
        designSize: const Size(411.42857142857144, 914.2857142857143),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: BlocProvider(
              create: (context) => CategoriesCubit(
                  CategoriesRepository(CategoriesDataProvider())),
              child: const CategoriesScreen(),
            ),
            onGenerateRoute: AppRouter().generateRoute,
          );
        });
  }
}
