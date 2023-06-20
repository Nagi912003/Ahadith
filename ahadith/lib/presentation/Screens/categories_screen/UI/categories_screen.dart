import 'package:ahadith/presentation/Screens/saved/saved_categories_screen/UI/saved_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../business_logic/categories_cubit/categories_cubit.dart';
import '../../../../business_logic/categories_cubit/categories_state.dart';

import '../../../../constants/strings.dart';
import '../../../../data/models/category.dart';
import '../widgets/categories_screen_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Category> categories;
  late List<Category> searchResult;
  bool _isSearching = false;
  bool _showingSaved = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              title: _buildSearchField(),
              leading: const BackButton(),
              actions: [_buildAppBarActions()],
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
        child: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            if (connected) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1.h),
                    child: SizedBox(
                      height: 0.9.sh,
                      width: 1.sw,
                      //color: Colors.deepPurple,
                        child: _showingSaved? const SavedCategoriesScreen():_buildBlocWidget(),
                    ),
                  ),
                  if(!_isSearching)Positioned(
                    top: 20,
                    right: 20,
                    child: Text(
                      appName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if(!_isSearching)Positioned(
                    top: 30,
                    left: 10,
                    child: TextButton(
                      child: Text(
                        !_showingSaved?'المحفوظات':'الفئات',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        setState(() {
                          _showingSaved = !_showingSaved;
                        });
                      },
                    ),
                  ),
                ],
              );
            } else {
              return buildNoInternetWidget(context);
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
      physics: const BouncingScrollPhysics(),
      itemCount: _searchController.text.isEmpty
          ? categories.length
          : searchResult.length,
      itemBuilder: (context, index) {
        return categoryItem(
            _searchController.text.isEmpty
                ? categories[index]
                : searchResult[index],
            context);
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search by category...',
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
      return IconButton(
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
