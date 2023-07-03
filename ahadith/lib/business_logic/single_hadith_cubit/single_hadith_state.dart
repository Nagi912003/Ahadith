import 'package:flutter/foundation.dart';

import '../../data/models/hadith.dart';

@immutable
abstract class SingleHadithState {}

class SingleHadithInitial extends SingleHadithState {}

class SingleHadithLoading extends SingleHadithState {}

class SingleHadithError extends SingleHadithState {
  final String message;

  SingleHadithError(this.message);
}

class SingleHadithLoaded extends SingleHadithState {
  final DetailedHadith hadith;

  SingleHadithLoaded(this.hadith);
}

class SingleHadithsLoaded extends SingleHadithState {
  final List<DetailedHadith> hadiths;

  SingleHadithsLoaded(this.hadiths);
}

class SingleHadithsLoading extends SingleHadithState {}

class SingleHadithsExists extends SingleHadithState {}

class SingleHadithsStop extends SingleHadithState {}

class SingleHadithsError extends SingleHadithState {
  final String message;

  SingleHadithsError(this.message);
}