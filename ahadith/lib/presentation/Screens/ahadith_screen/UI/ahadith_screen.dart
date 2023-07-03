import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_cubit.dart';
import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:ahadith/data/models/hadith.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/hadiths_cubit/hadiths_cubit.dart';
import '../../../../business_logic/hadiths_cubit/hadiths_state.dart';
import '../../../../business_logic/single_hadith_cubit/single_hadith_state.dart';
import '../../../../data/models/category.dart';
import '../widgets/ahadith_screen_widgets.dart';

class AhadithScreen extends StatefulWidget {
  const AhadithScreen(
      {super.key, required this.category, required this.themeManager});
  final Category category;
  final ThemeManager themeManager;

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  late List ahadith;
  int page = 1;
  bool _downloading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HadithsCubit>(context)
        .getAllHadith(categoryId: widget.category.id!, perPage: '1550');
  }

  void downloadHadiths() async {
    _downloading = true;

    Provider.of<FavoritesAndSavedProvider>(context, listen: false)
        .addSaved(ahadith as List<DetailedHadith>, widget.category);
    _downloading = false;

    // await Future.delayed(const Duration(milliseconds: 3000)).then((_) => {
    //   Provider.of<FavoritesAndSavedProvider>(context, listen: false)
    //           .addSaved(ahadith as List<DetailedHadith>, widget.category),
    //       _downloading = false,
    //     });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<FavoritesAndSavedProvider>(context, listen: false)
        .isSaved(widget.category.id!)) {
      _downloading = false;
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: widget.themeManager.appPrimaryColor,
        title: Text(widget.category.title!),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        actions: [
          BlocBuilder<SingleHadithCubit, SingleHadithState>(
            builder: (context, state) {
              if(state is SingleHadithsExists){
                return Icon(Icons.download_done_outlined, color: widget.themeManager.appPrimaryColor,);
              }else if(state is SingleHadithsStop){
                return Icon(
                  Icons.cancel_presentation_outlined,
                  color: Colors.red[200],
                );
              }
              else if (state is SingleHadithsLoaded) {
                ahadith = state.hadiths;

                downloadHadiths();

                return Provider.of<FavoritesAndSavedProvider>(context)
                        .isSaved(widget.category.id!)
                    ? const Icon(Icons.download_done_outlined)
                    : _downloading
                        ? RefreshProgressIndicator(
                            color: widget.themeManager.appPrimaryColor,
                          )
                        : IconButton(
                            icon: const Icon(Icons.downloading_outlined),
                            onPressed: () async {
                              setState(() {
                                _downloading = true;
                              });
                              await Future.delayed(
                                      const Duration(milliseconds: 0))
                                  .then((_) => {
                                        Provider.of<FavoritesAndSavedProvider>(
                                                context,
                                                listen: false)
                                            .addSaved(
                                                ahadith
                                                    as List<DetailedHadith>,
                                                widget.category),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'تم تحميل الأحاديث',
                                                textAlign:
                                                    TextAlign.center),
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                      });
                              _downloading = false;
                            });
              } else if (state is SingleHadithsLoading) {
                return Center(
                  child: RefreshProgressIndicator(
                    color: widget.themeManager.appPrimaryColor,
                  ),
                );
              } else if (state is SingleHadithsError) {
                print(state.message);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _downloading = false;
                  });
                    BlocProvider.of<SingleHadithCubit>(context).sayStop();
                });
                return Icon(
                  Icons.cancel_presentation_outlined,
                  color: Colors.red[200],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: widget.themeManager.appPrimaryColor,
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<HadithsCubit, HadithsState>(
        builder: (context, state) {
          if (state is HadithsLoaded) {
            ahadith = state.hadiths;

            if(!Provider.of<FavoritesAndSavedProvider>(context)
                .isSaved(widget.category.id!)){
              List<String> hadithIds = [];
              for (var hadith in ahadith) {
                hadithIds.add(hadith.id);
                if (hadithIds.length >= 100) break;
              }

              BlocProvider.of<SingleHadithCubit>(context)
                  .getHadiths(hadithIds: hadithIds);
            }else{
              BlocProvider.of<SingleHadithCubit>(context).sayExist();
            }


            return _downloading
                ? Stack(
                    children: [
                      buildAhadithList(ahadith, widget.category.title!, context,
                          widget.themeManager),
                      Container(
                        width: double.infinity,
                        height: 1.sh,
                        color: Colors.grey.shade800.withOpacity(0.4),
                        child: Center(
                          child: Card(
                            color: Colors.grey.shade900,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: widget.themeManager.appPrimaryColor,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'المرة الأولى لفتح هذه الفئة \n انتظر لحين حفظ الاحاديث',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : buildAhadithList(ahadith, widget.category.title!, context,
                    widget.themeManager);
          } else if (state is HadithsLoadedMore) {
            ahadith.addAll(state.hadiths);
            page++;
            return buildAhadithList(
                ahadith, widget.category.title!, context, widget.themeManager);
          } else if (state is HadithsLoading) {
            return Center(
              child: CircularProgressIndicator(
                  color: widget.themeManager.appPrimaryColor),
            );
          } else if (state is HadithsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                  color: widget.themeManager.appPrimaryColor),
            );
          }
        },
      ),
    );
  }
}
