import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../../../business_logic/categories_cubit/categories_cubit.dart';
import '../../../../business_logic/categories_cubit/categories_state.dart';

import '../../../../constants/strings.dart';
import '../../../../data/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Category> categories;
  late List<Category> searchResult;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        leading: _isSearching ? const BackButton() : _buildReload(),
        actions: [_buildAppBarActions()],
        //title: const Text('الفئات و الاحاديث'),
        // titleSpacing: 20,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return _buildBlocWidget();
            } else {
              return _buildNoInternetWidget();
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: _buildAppBarActions(),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset("assets/images/undraw_connected_world_wuay.png"),
              const Text(
                //"can't connect .. check the internet",
                "...حدث مشكلة في الاتصال",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.deepPurple,
                  //color: MyColors.mySecondary,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildBlocWidget() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoriesLoaded) {
          categories = state.categories;
          return _buildCategoriesList();
        } else if (state is CategoriesError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildCategoriesList() {
    return ListView.builder(
      itemCount: _searchController.text.isEmpty
          ? categories.length
          : searchResult.length,
      itemBuilder: (context, index) {
        return _categoryItem(_searchController.text.isEmpty
            ? categories[index]
            : searchResult[index]);
      },
    );
  }

  Widget _categoryItem(Category category) {
    return Card(
      child: ListTile(
        title: Text(category.title!),
        onTap: () {
          Navigator.of(context).pushNamed(
            ahadithScreen,
            arguments: category,
          );
        },
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return const Text(
      'الفئات و الاحاديث',
      style: TextStyle(
        color: Colors.black87,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildReload() {
    return TextButton(
      onPressed: () {
        BlocProvider.of<CategoriesCubit>(context).getAllCategories();
      },
      child: const Icon(
        Icons.refresh,
        size: 20,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search by title...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(fontSize: 16.0),
      onChanged: (query) {
        searchByTitle(query);
      },
    );
  }

  void searchByTitle(String query) {
    searchResult = categories
        .where((cat) => cat.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  Widget _buildAppBarActions() {
    if (_isSearching) {
      return IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _clearSearchQuery();
            Navigator.pop(context);
          },
        );
    } else {
      return
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        );
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
    });
  }
}
