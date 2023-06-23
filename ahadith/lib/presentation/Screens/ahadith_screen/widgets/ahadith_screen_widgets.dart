import 'package:flutter/material.dart';

import '../../../../constants/strings.dart';

Widget buildAhadithList(ahadithList,String categoryTitle ,BuildContext context) {
  return ListView.builder(
    physics: const BouncingScrollPhysics(),
    itemCount: ahadithList.length,
    itemBuilder: (context, index) {
      return Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          title: Text(
            '${index+1}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
          subtitle: Text(
            '${ahadithList[index].title!}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(hadithDetailedScreen, arguments: {
              'hadith': ahadithList[index]!,
              'categoryTitle': categoryTitle,
              'index': index,
            },);
          },
        ),
      );
    },
  );
}