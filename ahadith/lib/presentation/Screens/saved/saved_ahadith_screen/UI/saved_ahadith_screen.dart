import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../data/models/hadith.dart';

import 'package:ahadith/presentation/Screens/saved/saved_detailed_hadith/UI/saved_detailed_hadith.dart';

import '../../../hadith_detailed_screen/Widgets/hadith_detailed_screen_widgets.dart';

class SavedAhadithScreen extends StatelessWidget {
  const SavedAhadithScreen(
      {super.key,
      required this.categoryTitle,
      required this.ahadith,
      required this.themeManager,
      required this.categoryId});

  final String categoryTitle;
  final List<DetailedHadith> ahadith;
  final ThemeManager themeManager;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: themeManager.appPrimaryColor200,

        title: Text(categoryTitle),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        actions: [
          MaterialButton(
              // textColor: Colors.red[200],
              child: Icon(Icons.delete_outline, color: Colors.red[200],),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.black87,
                    title: SizedBox(
                      // height: 0.2.sh,
                      // width: 0.8.sw,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'هل انت متأكد من ازالة الفئة من المحفوظات ؟',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                                child: Text(
                                  'الرجوع',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Provider.of<FavoritesAndSavedProvider>(context, listen: false)
                                      .deleteFromSaved(categoryId);
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'ازالة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                      color:
                                      Colors.red[200]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
      body: buildAhadithList(ahadith, categoryTitle, context, themeManager),
    );
  }
}

Widget buildAhadithList(ahadithList, String categoryTitle, BuildContext context,
    ThemeManager themeManager) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: ahadithList.length,
    itemBuilder: (context, index) {
      return Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          title: Text(
            '${index + 1}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
          subtitle: Text(
            '${ahadithList[index].title!}',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
          onTap: () {
            final favoritesProvider =
                Provider.of<FavoritesAndSavedProvider>(context, listen: false);
            final isFavorite =
                favoritesProvider.isFavorite(ahadithList[index].id!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => savedDetailedHadith(
                  hadith: ahadithList[index],
                  isFavorite: isFavorite,
                  onPressed: () {
                    favoritesProvider.addFavorite(ahadithList[index].id!,
                        ahadithList[index], categoryTitle, index + 1, true);
                    snakeBarFavoriteMessage(false, context, themeManager);
                  },
                  index: index,
                  themeManager: themeManager,
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
