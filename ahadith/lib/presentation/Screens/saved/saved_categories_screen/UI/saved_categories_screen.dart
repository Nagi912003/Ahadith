import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ahadith/constants/strings.dart';

import 'package:ahadith/data/models/hadith.dart';

class SavedCategoriesScreen extends StatelessWidget {
  SavedCategoriesScreen({
    super.key,
    required this.savedCategoriesIds,
    required this.savedCategories,
    required this.savedCategoriesTitlesList,
    required this.themeManager,
    required this.listLength,
  });

  final savedCategoriesIds;

  final Map<String, List<DetailedHadith>> savedCategories;

  final List<String> savedCategoriesTitlesList;

  final bool isSearching = false;
  final ThemeManager themeManager;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    print(listLength);
    return SizedBox(
      height: listLength <= 1 ? null : listLength <= 2 ? 200.h : listLength == 3 ? 300.h : 400.h ,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Card(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'alnawawiforty.com   ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    'الاحاديث الاربعون النووية',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(NawawiHadithScreen, arguments: themeManager);
              },
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
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
                        'ahadith': savedCategories[
                            savedCategoriesIds.elementAt(index)],
                        'categoryTitle': savedCategoriesTitlesList[index],
                        'themeManager': themeManager,
                        'categoryId': savedCategoriesIds.elementAt(index),
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
