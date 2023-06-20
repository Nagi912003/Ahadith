import 'package:ahadith/constants/strings.dart';
import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/hadith.dart';

class SavedCategoriesScreen extends StatefulWidget {
  const SavedCategoriesScreen({super.key});

  @override
  State<SavedCategoriesScreen> createState() => _SavedCategoriesScreenState();
}

class _SavedCategoriesScreenState extends State<SavedCategoriesScreen> {
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
      backgroundColor: Colors.transparent,
      body: Center(
        child: savedCategoriesTitlesList.isEmpty
            ? Text('لا يوجد محفوظات بعد', style: TextStyle(fontSize: 30.sp, color: Colors.white),)
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: savedCategoriesTitlesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                        savedCategoriesTitlesList[index],
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.end,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          savedAhadithScreen,
                          arguments: {
                            'ahadith': savedCategories[savedCategoriesIds.elementAt(index)],
                            'categoryTitle': savedCategoriesTitlesList[index],
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
