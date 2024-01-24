import 'dart:io';

import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'hadith_detailed_screen_widgets.dart';
import '../../../../data/models/hadith.dart';

Widget buildDetailedHadith(DetailedHadith hadith, bool isFavorite,
    BuildContext context, onPressed, int index, ThemeManager themeManager) {
  return Scaffold(
    appBar: AppBar(
      foregroundColor: themeManager.appPrimaryColor200,
      title: Text(hadith.title!),
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      actions: [SizedBox(width: 10.w)],
    ),
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildCard('', hadith.hadeeth! + hadith.attribution!, true, context,
                themeManager),
            SizedBox(height: 20.h),
            hadithGrade(hadith.grade!, context, themeManager),
            SizedBox(height: 10.h),
            buildCard('التفسير : ', hadith.explanation!, false, context,
                themeManager),
            if (hadith.wordsMeanings!.isNotEmpty) SizedBox(height: 10.h),
            if (hadith.wordsMeanings!.isNotEmpty &&
                hadith.wordsMeanings.toString().length > 10)
              buildCard(
                  'معانى الكلمات : ',
                  hadith.wordsMeanings!.first.toString(),
                  false,
                  context,
                  themeManager),
            if (hadith.hints != null && hadith.hints != [])
              SizedBox(height: 10.h),
            if (hadith.hints != null && hadith.hints != [])
              buildCard('الدروس المستفادة : ', hadith.hints.toString(), false,
                  context, themeManager),
            SizedBox(height: 10.h),
            isFavorite
                ? buildButton(
                    '',
                    favoriteIcon(isFavorite, context, themeManager),
                    () {},
                    false,
                    context,
                    themeManager)
                : buildButton(
                    'أضف للمفضلة',
                    favoriteIcon(isFavorite, context, themeManager),
                    onPressed,
                    true,
                    context,
                    themeManager),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    ),
  );
}
