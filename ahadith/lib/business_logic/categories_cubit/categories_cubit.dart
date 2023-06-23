import 'package:bloc/bloc.dart';

import '../../data/models/category.dart';

import 'package:ahadith/data/repositories/categories_repository.dart';

import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {

  final CategoriesRepository categoriesRepository;
  List<Category> categories = [];

  CategoriesCubit(this.categoriesRepository) : super(CategoriesInitial());

  List<Category>getAllCategories() {
    emit(CategoriesLoading());
    categoriesRepository.getAllCategories().then((categories) => {
      emit(CategoriesLoaded(categories)),
      this.categories = categories
    } , onError: (e) {
      emit(CategoriesError(e.toString()));
    });
    return categories;
  }
}