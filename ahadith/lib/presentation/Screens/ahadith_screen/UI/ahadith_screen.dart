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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HadithsCubit>(context)
        .getAllHadith(categoryId: widget.category.id!,perPage: '1550');
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
                    : IconButton(icon:const Icon(Icons.downloading_outlined), onPressed: (){
                  Provider.of<FavoritesAndSavedProvider>(context,
                      listen: false)
                      .addSaved(ahadith as List<DetailedHadith>, widget.category);
                });
              } else if (state is SingleHadithsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SingleHadithsError) {
                return const Icon(Icons.cancel_presentation_outlined);
              } else {
                return const Center(
                  child: Icon(Icons.file_download_off_outlined),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HadithsCubit, HadithsState>(
        builder: (context, state) {
          if (state is HadithsLoaded) {
            ahadith = state.hadiths;

            List<String> hadithIds = [];
            ahadith.forEach((hadith) {
              hadithIds.add(hadith.id);
            });
            print('hadithIds: $hadithIds');

            BlocProvider.of<SingleHadithCubit>(context).getHadiths(hadithIds: hadithIds);

            return buildAhadithList(ahadith, widget.category.title!,context);
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
