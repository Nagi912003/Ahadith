import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:ahadith/business_logic/hadiths_cubit/hadiths_cubit.dart';
import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_cubit.dart';
import 'package:ahadith/data/data_providers/hadiths_data_provider.dart';
import 'package:ahadith/data/data_providers/single_hadith_provider.dart';
import 'package:ahadith/data/repositories/hadiths_repository.dart';
import 'package:ahadith/data/repositories/single_hadith_repository.dart';
import 'package:ahadith/presentation/Screens/hadith_detailed_screen/UI/hadith_detailed_screen.dart';
import 'package:ahadith/presentation/Screens/home_screen/home_screen.dart';
import 'package:ahadith/presentation/Screens/nawawis_ahadith_screen/nawawis_ahadith_screen.dart';
import 'package:ahadith/presentation/Screens/saved/saved_ahadith_screen/UI/saved_ahadith_screen.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../data/data_providers/categories_data_provider.dart';
import '../../data/models/category.dart';
import '../../data/models/hadith.dart';
import '../../data/repositories/categories_repository.dart';

import '../../business_logic/categories_cubit/categories_cubit.dart';
import '../Screens/ahadith_screen/UI/ahadith_screen.dart';
import '../Screens/categories_screen/UI/categories_screen.dart';
import '../Screens/favorites_screen/UI/favorites_screens.dart';

class AppRouter {
  late CategoriesRepository categoriesRepository;
  late CategoriesCubit categoriesCubit;

  late HadithsRepository hadithsRepository;
  late HadithsCubit hadithsCubit;

  AppRouter() {
    categoriesRepository = CategoriesRepository(CategoriesDataProvider());
    categoriesCubit = CategoriesCubit(categoriesRepository);

    hadithsRepository = HadithsRepository(HadithsDataProvider());
    hadithsCubit = HadithsCubit(hadithsRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        final themeManager = settings.arguments as ThemeManager;
        return MaterialPageRoute(
          builder: (_) => MyHomePage(themeManager: themeManager),
        );

      case categoriesScreen:
        final themeManager = settings.arguments as ThemeManager;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<SingleHadithCubit>.value(
                value: SingleHadithCubit(
                    SingleHadithRepository(SingleHadithDataProvider())),
              ),
              ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                value: Provider.of<FavoritesAndSavedProvider>(context),
              ),
            ],
            child: CategoriesScreen(themeManager: themeManager),
          ),
        );

      case ahadithScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final category = args['category'] as Category;
        final themeManager = args['themeManager'] as ThemeManager;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<SingleHadithCubit>.value(
                value: SingleHadithCubit(
                    SingleHadithRepository(SingleHadithDataProvider())),
              ),
              ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                value: Provider.of<FavoritesAndSavedProvider>(context),
              ),
              BlocProvider<HadithsCubit>.value(
                value: hadithsCubit,
              ),
            ],
            child: AhadithScreen(
              category: category,
              themeManager: themeManager,
            ),
          ),
        );

      case hadithDetailedScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final hadith = args['hadith'] as Hadith;
        final categoryTitle = args['categoryTitle'] as String;
        final index = args['index'] as int;
        final themeManager = args['themeManager'] as ThemeManager;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<SingleHadithCubit>.value(
                value: SingleHadithCubit(
                    SingleHadithRepository(SingleHadithDataProvider())),
              ),
              ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                value: Provider.of<FavoritesAndSavedProvider>(context),
              ),
            ],
            child: HadithDetailedScreen(
              hadith: hadith,
              categoryTitle: categoryTitle,
              hadithIndex: index,
              themeManager: themeManager,
            ),
          ),
        );

      case favoritesScreen:
        final themeManager = settings.arguments as ThemeManager;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
                value: Provider.of<FavoritesAndSavedProvider>(context),
              ),
            ],
            child: FavoritesScreen(themeManager: themeManager),
          ),
        );

      case savedAhadithScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final ahadith = args['ahadith'] as List<DetailedHadith>;
        final categoryTitle = args['categoryTitle'] as String;
        final themeManager = args['themeManager'] as ThemeManager;
        final categoryId = args['categoryId'] as String;
        return MaterialPageRoute(
          builder: (context) =>
              ChangeNotifierProvider<FavoritesAndSavedProvider>.value(
               value: Provider.of<FavoritesAndSavedProvider>(context),
               child: SavedAhadithScreen(
              categoryTitle: categoryTitle,
              ahadith: ahadith,
              themeManager: themeManager,
                 categoryId: categoryId,
            ),
          ),
        );

      case NawawiHadithScreen:
        final themeManager = settings.arguments as ThemeManager;
        return MaterialPageRoute(
          builder: (context) =>
              NawawisAhadithScreen(themeManager: themeManager),
        );

      default:
        return MaterialPageRoute(builder: (_) => const PageNotFound());
    }
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('page not found');
  }
}
