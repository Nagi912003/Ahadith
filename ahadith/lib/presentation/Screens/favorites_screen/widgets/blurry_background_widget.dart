import 'package:ahadith/presentation/Screens/hadith_detailed_screen/Widgets/hadith_detailed_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ahadith/data/models/hadith.dart';
import 'package:google_fonts/google_fonts.dart';

class BlurryBackgroundWidget extends StatefulWidget {
  final DetailedHadith hadith;
  final String hadithIndex;

  const BlurryBackgroundWidget({super.key, required this.hadith, required this.hadithIndex});

  @override
  _BlurryBackgroundWidgetState createState() => _BlurryBackgroundWidgetState();
}

class _BlurryBackgroundWidgetState extends State<BlurryBackgroundWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1000.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 25.0, right: 25.0),
            child: Text(
              '${widget.hadith.categories!.first}: ${int.parse(widget.hadithIndex)+1}\n\n${widget.hadith.title!}',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _expanded ? 600.h : 375.h,
            width: double.infinity,
            curve: Curves.decelerate,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                  top: 50.h, left: 50.w, right: 50.w, bottom: 100.h),
              height: 100.h,
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: _expanded
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        _expanded
                            ? '${widget.hadith.hadeeth!}\n\n${widget.hadith.explanation!}'
                            : widget.hadith.hadeeth!,
                        style: GoogleFonts.lateef(
                          // overflow: TextOverflow.fade,
                          color: Colors.white,
                          fontSize: 27.sp,
                          fontWeight: FontWeight.bold,
                          // fontFamily: Theme.of(context).textTheme.titleLarge?.fontFamily,
                        ),
                        textAlign: TextAlign.end,
                      ),
                      if (_expanded) SizedBox(height: 22.h),
                      if (_expanded) goToHadithButton('اذهب الى الحديث', widget.hadith),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(DetailedHadith hadith) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.light? Colors.white: Colors.grey.shade800,
        title: SizedBox(
          height: 0.8.sh,
          width: 0.8.sw,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              buildCard('', hadith.hadeeth! + hadith.attribution!, true,context),
              SizedBox(height: 20.h),
              hadithGrade(hadith.grade!, context),
              SizedBox(height: 10.h),
              buildCard('التفسير : ', hadith.explanation!, false,context),
              if (hadith.wordsMeanings!.isNotEmpty)
                SizedBox(height: 10.h),
              if (hadith.wordsMeanings!.isNotEmpty)
                buildCard(': معانى الكلمات\n ', hadith.wordsMeanings!.toList().toString(), false,context),
              SizedBox(height: 22.h),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('الرجوع', style: Theme.of(context).textTheme.bodySmall,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget goToHadithButton(title, hadith) {
    return OutlinedButton(
      onPressed: (){_showDialog(hadith);},
      style: OutlinedButton.styleFrom(
        foregroundColor: MediaQuery.of(context).platformBrightness == Brightness.light? Colors.deepPurple: Colors.deepPurple.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: MediaQuery.of(context).platformBrightness == Brightness.light? Colors.deepPurple: Colors.deepPurple.shade100,
          ),
        ),
      ),
      child: SizedBox(
        height: 60.h,
        child: Center(
          child: Text(title , style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: MediaQuery.of(context).platformBrightness == Brightness.light? Colors.white: Colors.deepPurple.shade100,
          ),),
        ),
      ),
    );
  }
}
