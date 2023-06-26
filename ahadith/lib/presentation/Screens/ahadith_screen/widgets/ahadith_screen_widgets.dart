import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../constants/strings.dart';

Widget buildAhadithList(ahadithList,String categoryTitle ,BuildContext context, ThemeManager themeManager) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: ahadithList.length,
    itemBuilder: (context, index) {
      return Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          title: Text(
            '${index+1}',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.end,
          ),
          subtitle: Text(
            '${ahadithList[index].title!}',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.end,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(hadithDetailedScreen, arguments: {
              'hadith': ahadithList[index]!,
              'categoryTitle': categoryTitle,
              'index': index,
              'themeManager': themeManager,
            },);
          },
        ),
      );
    },
  );
}