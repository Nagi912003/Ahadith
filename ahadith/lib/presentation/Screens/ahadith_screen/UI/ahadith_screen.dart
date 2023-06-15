import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_logic/hadiths_cubit/hadiths_cubit.dart';
import '../../../../business_logic/hadiths_cubit/hadiths_state.dart';
import '../../../../constants/strings.dart';
import '../../../../data/models/category.dart';

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
    Future.delayed(const Duration(seconds: 1));
    BlocProvider.of<HadithsCubit>(context).getAllHadith(categoryId: widget.category.id!);
  }

  void getMoreData() {
    BlocProvider.of<HadithsCubit>(context).getAllHadith(categoryId: widget.category.id!, page: (page+1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title!),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocBuilder<HadithsCubit,HadithsState>(
        builder: (context, state) {
          if (state is HadithsLoaded) {
            ahadith = state.hadiths;
            return _buildAhadithList();
          }else if (state is HadithsLoadedMore){
            ahadith.addAll(state.hadiths);
            page++;
            return _buildAhadithList();
          }else if (state is HadithsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (state is HadithsError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: getMoreData,
        child: const Icon(Icons.keyboard_double_arrow_down_rounded),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget _buildAhadithList() {
    return ListView.builder(
      itemCount: ahadith.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(ahadith[index].title!),
            onTap: () {
              Navigator.of(context).pushNamed(
                  hadithDetailedScreen,
                  arguments: ahadith[index]!
              );
            },
          ),
        );
      },
    );
  }
}
