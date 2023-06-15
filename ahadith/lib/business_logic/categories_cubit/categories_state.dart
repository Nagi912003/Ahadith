import 'package:flutter/foundation.dart';

import '../../data/models/category.dart' as category_model;

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesError extends CategoriesState {
  final String message;

  CategoriesError(this.message);
}

class CategoriesLoaded extends CategoriesState {
  final List<category_model.Category> categories;

  CategoriesLoaded(this.categories);
}