import 'package:ahadith/presentation/Screens/saved/saved_detailed_hadith/UI/saved_detailed_hadith.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/strings.dart';
import '../../../../../data/models/hadith.dart';
import '../../../ahadith_screen/widgets/ahadith_screen_widgets.dart';

class SavedAhadithScreen extends StatelessWidget {
  const SavedAhadithScreen({super.key, required this.categoryTitle, required this.ahadith});

  final String categoryTitle;
  final List<DetailedHadith> ahadith;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor:
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.deepPurple
            : Colors.deepPurple.shade100,

        title: Text(categoryTitle),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: _buildAhadithList(ahadith, categoryTitle,context),

      );
  }

  Widget _buildAhadithList(ahadithList,String categoryTitle ,BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: ahadithList.length,
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).cardColor,
          child: ListTile(
            title: Text(
              '$index',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
            subtitle: Text(
              '${ahadithList[index].title!}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => savedDetailedHadith(hadith: ahadithList[index],isFavorite: false,onPressed: (){},)));
            },
          ),
        );
      },
    );
  }
}
