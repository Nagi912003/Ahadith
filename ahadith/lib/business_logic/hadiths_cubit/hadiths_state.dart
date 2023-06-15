import 'package:flutter/foundation.dart';

import '../../data/models/hadith.dart';

@immutable
abstract class HadithsState {}

class HadithsInitial extends HadithsState {}

class HadithsLoading extends HadithsState {}

class HadithsError extends HadithsState {
  final String message;

  HadithsError(this.message);
}

class HadithsLoaded extends HadithsState {
  final List<Hadith> hadiths;

  HadithsLoaded(this.hadiths);
}

class HadithsLoadedMore extends HadithsState {
  final List<Hadith> hadiths;

  HadithsLoadedMore(this.hadiths);
}

class HadithsLoadingMore extends HadithsState {
  final List<Hadith> hadiths;

  HadithsLoadingMore(this.hadiths);
}

class HadithsErrorMore extends HadithsState {
  final String message;

  HadithsErrorMore(this.message);
}

class HadithsNoMore extends HadithsState {
  final List<Hadith> hadiths;

  HadithsNoMore(this.hadiths);
}