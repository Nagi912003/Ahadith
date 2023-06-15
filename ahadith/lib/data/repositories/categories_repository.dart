import 'package:ahadith/data/models/category.dart';

import '../data_providers/categories_data_provider.dart';

class CategoriesRepository {
  final CategoriesDataProvider _categoriesDataProvider;
  CategoriesRepository(this._categoriesDataProvider);

  Future<List<Category>> getAllCategories() async{
    final categories = await _categoriesDataProvider.getAllCategories();
    return categories.map((category) => Category.fromJson(category)).toList();
  }
}