import 'package:ahadith/helpers/notification_service.dart';
import 'package:ahadith/presentation/Screens/categories_screen/widgets/random_hadith.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/categories_cubit/categories_cubit.dart';
import '../../../../business_logic/categories_cubit/categories_state.dart';

import '../../../../constants/strings.dart';
import '../../../../data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/hadith.dart';

import 'package:ahadith/presentation/Screens/saved/saved_ahadith_screen/UI/saved_ahadith_screen.dart';
import 'package:ahadith/presentation/Screens/saved/saved_categories_screen/UI/saved_categories_screen.dart';
import '../../../../theme/theme_manager.dart';
import '../../azkar_screen/UI/azkar_screen.dart';
import '../../hadith_detailed_screen/Widgets/hadith_detailed_screen_widgets.dart';
import '../../saved/saved_detailed_hadith/UI/saved_detailed_hadith.dart';
import '../widgets/categories_screen_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.themeManager});

  final ThemeManager themeManager;

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
    final randomAhadith = savedProvider.randomAhadith;

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawerScrimColor: widget.themeManager.appPrimaryColor200.withOpacity(0.2),
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
          : AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: widget.themeManager.appPrimaryColor200,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: OurAppbar(),
              backgroundColor: Colors.transparent,
            ),
      body: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 1),
              child: SizedBox(
                height: 0.86.sh,
                width: 1.sw,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'َوَمَا يَنطِقُ عَنِ الْهَوَىٰ\nإِنْ هُوَ إِلَّا وَحْيٌ يُوحَىٰ',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .fontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Card(
                        color: Colors.transparent,
                        child: ExpansionTile(
                          controller: _savedExpansionTileController,
                          initiallyExpanded: _showingSaved,
                          collapsedBackgroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          iconColor: widget.themeManager.appPrimaryColor200,
                          collapsedIconColor:
                              widget.themeManager.appPrimaryColorInverse,
                          title: Text(
                            'الأحاديث المحفوظة',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          children: [
                            _searchController.text.isNotEmpty &&
                                    _isSearchingInSaved
                                ? buildAhadithList(
                                    savedCategoriesSearchResultOfAhadith,
                                    'نتيجة البحث',
                                    context,
                                    widget.themeManager)
                                : SavedCategoriesScreen(
                                    savedCategories: savedCategories,
                                    savedCategoriesTitlesList:
                                        savedCategoriesTitlesList,
                                    savedCategoriesIds: savedCategoriesIds,
                                    themeManager: widget.themeManager,
                                    listLength: savedCategories.length,
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
                          iconColor: widget.themeManager.appPrimaryColor200,
                          collapsedIconColor:
                              widget.themeManager.appPrimaryColor200,
                          title: Container(
                            width: 1.sw,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    'فئات موسوعة الأحاديث',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    '          ',
                                    // '         HadeethEnc.com      ',
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
                                    child: RefreshProgressIndicator(
                                      color: widget.themeManager.appPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  return buildNoInternetWidget(
                                      context, widget.themeManager);
                                }
                              },
                              child: CircularProgressIndicator(
                                color: widget.themeManager.appPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RandomHadith(themeManager: widget.themeManager),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black54,
        child: ListView(children: [
          DrawerHeader(
            child: SizedBox(
              height: 200,
              child: Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'اللَهُمَّ صّلِ وسَلّمْ عَلى نَبِيْنَا مُحَمد ﷺ',
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: widget.themeManager.appPrimaryColor200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'المظهر',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              trailing: DropdownButton<int>(
                iconDisabledColor: widget.themeManager.appPrimaryColor,
                iconEnabledColor: widget.themeManager.appPrimaryColor,
                borderRadius: BorderRadius.circular(10),
                isDense: true,
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: DropdownMenuItem(
                      value: 1,
                      child: Image.asset('assets/images/watercolor.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: DropdownMenuItem(
                      value: 2,
                      child: Image.asset('assets/images/watercolor-p.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: DropdownMenuItem(
                      value: 3,
                      child: Image.asset('assets/images/watercolor-off.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: DropdownMenuItem(
                      value: 4,
                      child: Image.asset('assets/images/watercolor-b.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: DropdownMenuItem(
                      value: 5,
                      child: Image.asset('assets/images/watercolor-g.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 7,
                    child: DropdownMenuItem(
                      value: 7,
                      child: Image.asset('assets/images/watercolor-bw.png'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 8,
                    child: DropdownMenuItem(
                      value: 8,
                      child: Image.asset('assets/images/watercolor-grey.png'),
                    ),
                  ),
                ],
                value: widget.themeManager.mode,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: widget.themeManager.appPrimaryColor200,
                ),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
                underline: const SizedBox(height: 0),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.themeManager.mode = newValue!;
                    widget.themeManager.toggleBackGroundImage(newValue);
                  });
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'حجم الخط',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  activeColor: widget.themeManager.appPrimaryColor200,
                  value: widget.themeManager.fontSize,
                  min: -10,
                  max: 10,
                  divisions: 20,
                  label: '${widget.themeManager.fontSize}',
                  onChanged: (double value) {
                    setState(() {
                      widget.themeManager.toggleFontSize(value);
                    });
                  },
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('الأذكار',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AzkarScreen(
                    themeManager: widget.themeManager,
                  ),
                ));
              },
            ),
          ),
          Card(
            child: ExpansionTile(
              collapsedIconColor: widget.themeManager.appPrimaryColor,
              iconColor: widget.themeManager.appPrimaryColor,
              title: Text(
                'الاحاديــث اليومية' + '  ${randomAhadith.length}',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
              children: randomAhadith
                  .map((e) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(e.title!),
                            onTap: () {
                              final favoritesProvider =
                                  Provider.of<FavoritesAndSavedProvider>(
                                      context,
                                      listen: false);
                              final isFavorite =
                                  favoritesProvider.isFavorite(e.id!);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => savedDetailedHadith(
                                  themeManager: widget.themeManager,
                                  isFavorite: isFavorite,
                                  hadith: e,
                                  onPressed: () {
                                    favoritesProvider.addFavorite(
                                        e.id!,
                                        e,
                                        'الاحاديــث اليومية',
                                        randomAhadith.length,
                                        true);
                                    snakeBarFavoriteMessage(
                                        false, context, widget.themeManager);
                                  },
                                  index: randomAhadith.indexOf(e),
                                ),
                              ));
                            },
                          ),
                          const Divider(),
                        ],
                      ))
                  .toList(),
            ),
          ),
          ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.notifications,
                color: widget.themeManager.appPrimaryColor200,
                size: 30.sp,
              ),
              onPressed: () {
                NotificationsServices notificationsServices =
                NotificationsServices();
                // notificationsServices.sendNotification('حديث اليوم', 'لا تنسى أذكار الصباح و المساء');
                notificationsServices.sendNotification('حديث اليوم', 'صل على نبينا محمد - \nلا تنسى أذكار الصباح و المساء');
              },
            ),
            onTap: null,
          ),
        ]),
      ),
    );
  }

  Widget _buildBlocWidget() {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: widget.themeManager.appPrimaryColor,
            ),
          );
        } else if (state is CategoriesLoaded) {
          categories = state.categories;
          return _buildCategoriesList();
        } else if (state is CategoriesError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: widget.themeManager.appPrimaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 400.h,
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
              context,
              widget.themeManager);
        },
      ),
    );
  }

  Widget _buildSearchField(int searchType) {
    return TextField(
      textAlign: TextAlign.end,
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
        fontSize: 25.0.sp ,
        fontFamily: Theme.of(context).textTheme.displaySmall!.fontFamily,
      ),
      autocorrect: true,
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
    // if(firstSearch) {
    //   Provider.of<FavoritesAndSavedProvider>(context, listen: false)
    //       .buildInvertedIndex();
    //   firstSearch = false;
    // }
    // List<DetailedHadith> savedCategoriesSearchResultOfAhadithTemp = [];
    // savedCategories.values.toList().forEach((detailedHadithList) {
    //   savedCategoriesSearchResultOfAhadithTemp += detailedHadithList;
    // });
    // savedCategoriesSearchResultOfAhadith =
    //     savedCategoriesSearchResultOfAhadithTemp
    //         .where((hadith) => hadith.title!.contains(hadeethTitle))
    //         .toList();
    //
    savedCategoriesSearchResultOfAhadith = [];
    savedCategoriesSearchResultOfAhadith =
        Provider.of<FavoritesAndSavedProvider>(context, listen: false)
            .searchByHadeethInSaved(hadeethTitle);

    setState(() {});
  }

  Widget _buildAppBarActions() {
    if (_isSearching) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          color: widget.themeManager.appPrimaryColor200,
        ),
        onPressed: () {
          _clearSearchQuery();
          Navigator.pop(context);
        },
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.search,
          color: widget.themeManager.appPrimaryColor,
        ),
        onPressed: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(300.w, 50.h, 30.w, 750.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              items: [
                PopupMenuItem(
                  value: 1,
                  child: Text('البحث عن فئة أحاديث', style: TextStyle(fontSize: 20+widget.themeManager.fontSize),),
                  onTap: () {
                    _startSearch(1);
                  },
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('البحث عن حديث في المحفوظات' , style: TextStyle(fontSize: 20+widget.themeManager.fontSize),),
                  onTap: () {
                    _startSearch(2);
                  },
                ),
              ]);
        },
      );
    }
  }

  Widget OurAppbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 0.75.sw,
        child: Row(
          children: [
            Text(
              HijriCalendar.now().toFormat('dd MMMM yyyy'),
              style: TextStyle(
                fontSize: 18.sp,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
            const Spacer(),
            Text(
              appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10),
            _buildAppBarActions(),
          ],
        ),
      ),
    );
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
