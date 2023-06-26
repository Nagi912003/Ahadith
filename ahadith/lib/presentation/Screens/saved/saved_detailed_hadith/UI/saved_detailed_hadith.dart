import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import 'package:ahadith/presentation/Screens/hadith_detailed_screen/Widgets/build_detailed_hadith_widget.dart';

import '../../../../../data/models/hadith.dart';

class savedDetailedHadith extends StatelessWidget {
  const savedDetailedHadith({super.key, required this.hadith, required this.isFavorite, required this.onPressed, required this.index, required this.themeManager});

  final DetailedHadith hadith;
  final bool isFavorite;
  final Function onPressed;
  final int index;
  final ThemeManager themeManager;

  @override
  Widget build(BuildContext context) {
    return buildDetailedHadith( hadith, isFavorite, context, onPressed, index,themeManager);
  }
}
