import 'package:ahadith/data/models/hadith.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

Widget CapturedWidget({required DetailedHadith hadith, hadithIndex,bool isRandom = false, required BuildContext context}) {
  String hadeeth = hadith.hadeeth!;
  if(isRandom){hadeeth = '${hadith.hadeeth} ${hadith.attribution}';}
  final textLength = hadeeth.length;
  return SizedBox(
    height: 1000.h,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
          child: isRandom? Text(
            'حديـــــث اليوم',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontSize: 32.sp,
            ),
            textAlign: TextAlign.center,
          ):Text(
            '${hadith.categories!.first}: $hadithIndex\n\n${hadith.attribution!}',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 50.h,
            left: 50.w,
            right: 50.w,
            bottom: 100.h,
          ),
          height: textLength < 120
              ? 190.h
              : textLength < 160
              ? 220.h
              : textLength < 190
              ? 240.h
              : textLength < 220
              ? 260.h
              : textLength < 250
              ? 280.h
              : textLength < 280
              ? 300.h
              : textLength < 310
              ? 320.h
              : textLength < 340
              ? 340.h
              : textLength < 370
              ? 360.h
              : textLength < 400
              ? 380.h
              : textLength < 430
              ? 400.h
              : textLength < 460
              ? 420.h
              : textLength < 490
              ? 440.h
              : textLength <
              520
              ? 460.h
              : textLength <
              550
              ? 480.h
              : 500.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
            children: [
              Text(
                hadeeth,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  // overflow: TextOverflow.fade,
                  color: Colors.white,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  // fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Text('HadeethEnc.com', style: TextStyle(color: Colors.white54)),
      ],
    ),
  );
}