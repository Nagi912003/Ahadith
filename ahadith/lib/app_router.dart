import 'package:ahadith/business_logic/hadiths_cubit/hadiths_cubit.dart';
import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_cubit.dart';
import 'package:ahadith/data/data_providers/hadiths_data_provider.dart';
import 'package:ahadith/data/data_providers/single_hadith_provider.dart';
import 'package:ahadith/data/repositories/hadiths_repository.dart';
import 'package:ahadith/data/repositories/single_hadith_repository.dart';
import 'package:ahadith/presentation/Screens/hadith_detailed_screen/UI/hadith_detailed_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';
import 'data/data_providers/categories_data_provider.dart';
import 'data/models/category.dart';
import 'data/models/hadith.dart';
import 'data/repositories/categories_repository.dart';

import 'business_logic/categories_cubit/categories_cubit.dart';
import 'presentation/Screens/ahadith_screen/UI/ahadith_screen.dart';
import 'presentation/Screens/categories_screen/UI/categories_screen.dart';

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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => categoriesCubit,
            child: const CategoriesScreen(),
          ),
        );

      case categoriesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => categoriesCubit,
            child: const CategoriesScreen(),
          ),
        );

      case ahadithScreen:
        final category = settings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<HadithsCubit>.value(
            value: hadithsCubit,
            child: AhadithScreen(
              category: category,
            ),
          ),
        );

        case hadithDetailedScreen:
          final hadith = settings.arguments as Hadith;
          return MaterialPageRoute(
            builder: (_) => BlocProvider<SingleHadithCubit>.value(
              value: SingleHadithCubit(SingleHadithRepository(SingleHadithDataProvider())),
              child: HadithDetailedScreen(hadith: hadith,),
            ),
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
