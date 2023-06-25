import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/categories_cubit/categories_cubit.dart';
import '../../../../business_logic/categories_cubit/categories_state.dart';

import '../../../../constants/strings.dart';
import '../../../../data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/hadith.dart';

import 'package:ahadith/presentation/Screens/saved/saved_ahadith_screen/UI/saved_ahadith_screen.dart';
import 'package:ahadith/presentation/Screens/saved/saved_categories_screen/UI/saved_categories_screen.dart';
import '../widgets/categories_screen_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Category> categories;
  List<Category> categoriesSearchResult = [];

  late Map<String, List<DetailedHadith>> savedCategories;
  List<DetailedHadith> savedCategoriesSearchResultOfAhadith = [];

  bool _isSearching = false;
  bool _isSearchingInAll = false;
  bool _isSearchingInSaved = false;

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

  bool _showingAll = false;
  bool _showingSaved = false;

  final ExpansionTileController _savedExpansionTileController =
      ExpansionTileController();
  final ExpansionTileController _allExpansionTileController =
      ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CategoriesCubit>(context).getAllCategories();
    final savedProvider = Provider.of<FavoritesAndSavedProvider>(context);

    final savedCategoriesIds = savedProvider.savedCategoriesIds;

    savedCategories = savedProvider.savedCategories;

    final List<String> savedCategoriesTitlesList =
        savedProvider.savedCategoriesTitlesList;

    return Scaffold(
      appBar: _isSearching
          ? AppBar(
              title: _isSearchingInAll
                  ? _buildSearchField(1)
                  : _buildSearchField(2),
              leading: const BackButton(),
              actions: [_buildAppBarActions()],
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, 1.h),
              child: SizedBox(
                height: 0.9.sh,
                width: 1.sw,
                //color: Colors.deepPurple,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // SizedBox(height: 0.68.sh),
                      SizedBox(
                        height: 20.h,
                      ),
                      Card(
                        color: Colors.transparent,
                        child: ExpansionTile(
                          controller: _savedExpansionTileController,
                          initiallyExpanded: _showingSaved,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          title: Text(
                            'المحفوظات',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          children: [
                            _searchController.text.isNotEmpty &&
                                    _isSearchingInSaved
                                ? buildAhadithList(
                                    savedCategoriesSearchResultOfAhadith,
                                    'نتيجة البحث',
                                    context)
                                : SavedCategoriesScreen(
                                    savedCategories: savedCategories,
                                    savedCategoriesTitlesList:
                                        savedCategoriesTitlesList,
                                    savedCategoriesIds: savedCategoriesIds,
                                  ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.transparent,
                        child: ExpansionTile(
                          controller: _allExpansionTileController,
                          initiallyExpanded: _showingAll,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          title: Row(
                            children: [
                              Text(
                                'الفئات',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '         HadeethEnc.com      ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                              OfflineBuilder(
                                connectivityBuilder: (
                                  BuildContext context,
                                  ConnectivityResult connectivity,
                                  Widget child,
                                ) {
                                  final bool connected =
                                      connectivity != ConnectivityResult.none;
                                  if (connected) {
                                    return const Icon(
                                      Icons.wifi,
                                      color: Colors.green,
                                    );
                                  } else {
                                    return Icon(
                                      Icons.wifi_off_rounded,
                                      color: Colors.red[200],
                                    );
                                  }
                                },
                                child: const RefreshProgressIndicator(),
                              ),
                            ],
                          ),
                          children: [
                            OfflineBuilder(
                              connectivityBuilder: (
                                BuildContext context,
                                ConnectivityResult connectivity,
                                Widget child,
                              ) {
                                final bool connected =
                                    connectivity != ConnectivityResult.none;
                                if (connected) {
                                  BlocProvider.of<CategoriesCubit>(context)
                                      .getAllCategories();
                                  return _buildBlocWidget();
                                } else {
                                  return buildNoInternetWidget(context);
                                }
                              },
                              child: const CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!_isSearching)
              Positioned(
                top: 20,
                right: 20,
                child: Text(
                  appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
          ],
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
    return SizedBox(
      height: 0.8.sh,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: _searchController.text.isEmpty && !_isSearchingInAll
            ? categories.length
            : categoriesSearchResult.length,
        itemBuilder: (context, index) {
          return categoryItem(
              _searchController.text.isEmpty && !_isSearchingInAll
                  ? categories[index]
                  : categoriesSearchResult[index],
              context);
        },
      ),
    );
  }

  // Widget _buildSavedList() {
  //   return SizedBox(
  //     height: 0.8.sh,
  //     child: ListView.builder(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 10.w,
  //         vertical: 10.h,
  //       ),
  //       physics: const BouncingScrollPhysics(),
  //       itemCount: _searchController.text.isEmpty
  //           ? categories.length
  //           : categoriesSearchResult.length,
  //       itemBuilder: (context, index) {
  //         return categoryItem(
  //             _searchController.text.isEmpty
  //                 ? categories[index]
  //                 : categoriesSearchResult[index],
  //             context);
  //       },
  //     ),
  //   );
  // }

  Widget _buildSearchField(int searchType) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: searchType == 1
            ? 'البحث في الفئات...'
            : 'البحث في الاحاديث المحفوظة...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: TextStyle(
          fontSize: 25.0,
          fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily),
      onChanged: (query) {
        searchType == 1
            ? searchByCategoriesTitle(query)
            : searchByHadithInSaved(query);
      },
    );
  }

  void searchByCategoriesTitle(String categoryTitle) {
    categoriesSearchResult = categories
        .where((cat) =>
            cat.title!.toLowerCase().contains(categoryTitle.toLowerCase()))
        .toList();
    setState(() {});
  }

  void searchByHadithInSaved(String hadeethTitle) {
    List<DetailedHadith> savedCategoriesSearchResultOfAhadithTemp = [];
    savedCategories.values.toList().forEach((detailedHadithList) {
      savedCategoriesSearchResultOfAhadithTemp += detailedHadithList;
    });
    savedCategoriesSearchResultOfAhadith =
        savedCategoriesSearchResultOfAhadithTemp
            .where((hadith) => hadith.title!.contains(hadeethTitle))
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
        onPressed: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(280.w, 700.h, 50.w, 100.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              items: [
                PopupMenuItem(
                  value: 1,
                  child: const Text('البحث في الكل'),
                  onTap: () {
                    _startSearch(1);
                  },
                ),
                PopupMenuItem(
                  value: 2,
                  child: const Text('البحث في المحفوظات'),
                  onTap: () {
                    _startSearch(2);
                  },
                ),
              ]);
        },
      );
    }
  }

  void _startSearch(int searchType) {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      switch (searchType) {
        case 1:
          _isSearchingInAll = true;
          _showingAll = true;
          _allExpansionTileController.expand();

          _isSearchingInSaved = false;
          _showingSaved = false;
          _savedExpansionTileController.collapse();
          break;
        case 2:
          _isSearchingInSaved = true;
          _showingSaved = true;
          _savedExpansionTileController.expand();

          _isSearchingInAll = false;
          _showingAll = false;
          _allExpansionTileController.collapse();
          break;
      }
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
      _isSearchingInAll = false;
      _isSearchingInSaved = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
    });
  }
}
