import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'hadith_detailed_screen_widgets.dart';
import'../../../../data/models/hadith.dart';

Widget buildDetailedHadith(DetailedHadith hadith, bool isFavorite,BuildContext context, onPressed, int index){
  return Scaffold(
    appBar: AppBar(
      foregroundColor:
      MediaQuery.of(context).platformBrightness == Brightness.light
          ? Colors.deepPurple
          : Colors.deepPurple.shade100,
      title: Text(hadith.title!),
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
    ),
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildCard('', hadith.hadeeth! + hadith.attribution!, true,context),
            SizedBox(height: 20.h),
            hadithGrade(hadith.grade!, context),
            SizedBox(height: 10.h),
            buildCard('التفسير : ', hadith.explanation!, false,context),
            if (hadith.wordsMeanings!.isNotEmpty)
              SizedBox(height: 10.h),
            if (hadith.wordsMeanings!.isNotEmpty && hadith.wordsMeanings.toString().length>10)
              buildCard(': معانى الكلمات\n ', hadith.wordsMeanings!.first.toString(), false,context),
            if (hadith.hints != null)SizedBox(height: 10.h),
            if (hadith.hints != null)buildCard(': الدروس المستفادة\n ', hadith.hints.toString(), false,context),
            SizedBox(height: 10.h),
            isFavorite? buildButton('', favoriteIcon(isFavorite, context), (){} , false, context):buildButton('اضف للمفضله', favoriteIcon(isFavorite, context), onPressed, true, context),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     buildButton('', favoriteIcon(isFavorite, context), onPressed, false, context),
            //     buildButton('اظهار السند', const Icon(Icons.favorite),
            //         showReference(hadith.reference!,context), true, context),
            //   ],
            // ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    ),
  );
}