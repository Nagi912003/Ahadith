import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/hadith.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedProvider = Provider.of<FavoritesAndSavedProvider>(context);

    final savedCategoriesIds = savedProvider.savedCategoriesIds;

    final Map<String, List<DetailedHadith>> savedCategories =
        savedProvider.savedCategories;

    final Map<String, String> savedCategoriesTitles =
        savedProvider.savedCategoriesTitles;

    final List<String> savedCategoriesTitlesList =
        savedProvider.savedCategoriesTitlesList;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: savedCategoriesIds.isEmpty
            ? const Text('no saved yet')
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: savedCategoriesIds.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                        savedCategoriesTitlesList[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
      ),
    );
  }
}
