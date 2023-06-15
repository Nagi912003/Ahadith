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