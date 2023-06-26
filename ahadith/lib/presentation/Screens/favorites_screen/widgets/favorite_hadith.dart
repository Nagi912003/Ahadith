import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/hadith.dart';
import 'blurry_background_widget.dart';


class FavoriteHadith extends StatelessWidget {
  const FavoriteHadith({super.key, required this.hadith, required this.hadithIndex, this.isRandom = false, required this.themeManager});
  final DetailedHadith hadith;
  final String hadithIndex;
  final isRandom;
  final ThemeManager themeManager;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurryBackgroundWidget(hadith: hadith, hadithIndex: hadithIndex, isRandom: isRandom, themeManager: themeManager,),
    );
  }
}