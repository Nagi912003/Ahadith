import 'package:ahadith/data/models/hadith.dart';
import 'package:ahadith/presentation/Screens/favorites_screen/widgets/blurry_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesAndSavedProvider>(context);
    final favoriteItems = favoritesProvider.favoriteItems;
    final favotiesCount = favoritesProvider.favoriteCount;
    return favotiesCount != 0
                    ? PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    return FavoriteHadith(
                      hadith: favoriteItems[index],
                    );
                  },
                ): const Center(
                  child: Text('لا يوجد أحاديث مفضلة'),
                );
  }
}

class FavoriteHadith extends StatelessWidget {
  const FavoriteHadith({super.key, required this.hadith});
  final DetailedHadith hadith;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurryBackgroundWidget(hadith: hadith),
    );
  }
}
