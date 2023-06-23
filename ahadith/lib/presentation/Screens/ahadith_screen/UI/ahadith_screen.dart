import 'package:ahadith/business_logic/single_hadith_cubit/single_hadith_cubit.dart';
import 'package:ahadith/data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import 'package:ahadith/data/models/hadith.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/hadiths_cubit/hadiths_cubit.dart';
import '../../../../business_logic/hadiths_cubit/hadiths_state.dart';
import '../../../../business_logic/single_hadith_cubit/single_hadith_state.dart';
import '../../../../data/models/category.dart';
import '../widgets/ahadith_screen_widgets.dart';

class AhadithScreen extends StatefulWidget {
  const AhadithScreen({super.key, required this.category});
  final Category category;

  @override
  State<AhadithScreen> createState() => _AhadithScreenState();
}

class _AhadithScreenState extends State<AhadithScreen> {
  late List ahadith;
  int page = 1;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HadithsCubit>(context)
        .getAllHadith(categoryId: widget.category.id!, perPage: '1550');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.deepPurple
                : Colors.deepPurple.shade100,

        title: Text(widget.category.title!),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        actions: [
          BlocBuilder<SingleHadithCubit, SingleHadithState>(
            builder: (context, state) {
              if (state is SingleHadithsLoaded) {
                ahadith = state.hadiths;
                return Provider.of<FavoritesAndSavedProvider>(context)
                        .isSaved(widget.category.id!)
                    ? const Icon(Icons.download_done_outlined)
                    : _downloading? const RefreshProgressIndicator():IconButton(
                        icon: const Icon(Icons.downloading_outlined),
                        onPressed: () async {
                          setState(() {
                            _downloading = true;
                          });
                          await Future.delayed(
                                  const Duration(milliseconds: 2500))
                              .then((_) => {
                                    Provider.of<FavoritesAndSavedProvider>(
                                            context,
                                            listen: false)
                                        .addSaved(
                                            ahadith as List<DetailedHadith>,
                                            widget.category),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('تم تحميل الأحاديث',
                                            textAlign: TextAlign.center),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  });
                          _downloading = false;
                        });
              } else if (state is SingleHadithsLoading) {
                return const Center(
                  child: RefreshProgressIndicator(),
                );
              } else if (state is SingleHadithsError) {
                return const Icon(Icons.cancel_presentation_outlined);
              } else {
                return const Center(
                  child: RefreshProgressIndicator(),
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

            List<String> hadithIds = [];
            for (var hadith in ahadith) {
              hadithIds.add(hadith.id);
              if (hadithIds.length >= 100) break;
            }

            BlocProvider.of<SingleHadithCubit>(context)
                .getHadiths(hadithIds: hadithIds);

            return buildAhadithList(ahadith, widget.category.title!, context);
          } else if (state is HadithsLoadedMore) {
            ahadith.addAll(state.hadiths);
            page++;
            return buildAhadithList(ahadith, widget.category.title!, context);
          } else if (state is HadithsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HadithsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
