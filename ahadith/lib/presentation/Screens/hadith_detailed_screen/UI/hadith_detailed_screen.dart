import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ahadith/data/models/hadith.dart';

import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_state.dart';
import '../../../../data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import '../../../../business_logic/single_hadith_cubit/single_hadith_cubit.dart';

import 'package:ahadith/presentation/Screens/hadith_detailed_screen/Widgets/hadith_detailed_screen_widgets.dart';

class HadithDetailedScreen extends StatefulWidget {
  const HadithDetailedScreen({super.key, required this.hadith, required this.categoryTitle,required this.hadithIndex, required this.themeManager});

  final Hadith hadith;
  final String categoryTitle;
  final int hadithIndex;
  final ThemeManager themeManager;

  @override
  State<HadithDetailedScreen> createState() => _HadithDetailedScreenState();
}

class _HadithDetailedScreenState extends State<HadithDetailedScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SingleHadithCubit>(context)
        .getHadith(hadithId: widget.hadith.id!);
    Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final fASProvider = Provider.of<FavoritesAndSavedProvider>(context,listen: false);
    BlocProvider.of<SingleHadithCubit>(context)
        .getHadith(hadithId: widget.hadith.id!);
    return Scaffold(
      appBar: appbar(context,widget.hadith.title!),
      body: BlocBuilder<SingleHadithCubit, SingleHadithState>(
        builder: (context, state) {
          if (state is SingleHadithLoaded) {
            bool isFavorite = fASProvider.isFavorite(state.hadith.id!);
            // bool isSaved = fASProvider.isSaved(state.hadith.id!);
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildCard('', state.hadith.hadeeth! + state.hadith.attribution!, true,context,widget.themeManager),
                    SizedBox(height: 20.h),
                    hadithGrade(state.hadith.grade!, context,widget.themeManager),
                    SizedBox(height: 10.h),
                    buildCard('التفسير : ', state.hadith.explanation!, false,context,widget.themeManager),
                    if (state.hadith.wordsMeanings!.isNotEmpty)
                      SizedBox(height: 10.h),
                    if (state.hadith.wordsMeanings!.isNotEmpty)
                      buildCard(': معانى الكلمات\n ', state.hadith.wordsMeanings!.toList().toString(), false,context,widget.themeManager),
                    SizedBox(height: 10.h),
                    buildCard(': الدروس المستفادة\n ', state.hadith.hints.toString(), false,context,widget.themeManager),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildButton('', favoriteIcon(isFavorite, context,widget.themeManager), () async => {
                                  fASProvider
                                      .toggleFavorite(state.hadith.id!,state.hadith,widget.categoryTitle,widget.hadithIndex,false),
                                  snakeBarFavoriteMessage(isFavorite,context,widget.themeManager),
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  }),
                                }, false, context,widget.themeManager),
                        buildButton('اظهار السند', const Icon(Icons.favorite),
                            showReference(state.hadith.reference!,context,widget.themeManager), true, context,widget.themeManager),
                      ],
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            );
          } else if (state is SingleHadithError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: widget.themeManager.appPrimaryColor,),
            );
          }
        },
      ),
    );
  }
}
