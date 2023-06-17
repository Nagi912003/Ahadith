import 'package:bloc/bloc.dart';

import '../../data/repositories/single_hadith_repository.dart';
import 'package:ahadith/data/models/hadith.dart';

import 'single_hadith_state.dart';

class SingleHadithCubit extends Cubit<SingleHadithState> {

  final SingleHadithRepository singleHadithRepository;
  DetailedHadith hadith = DetailedHadith();

  SingleHadithCubit(this.singleHadithRepository) : super(SingleHadithInitial());

  DetailedHadith getHadith({required String hadithId}) {
    singleHadithRepository.getHadith(hadithId: hadithId).then((hadith) => {
      emit(SingleHadithLoaded(hadith)),
      this.hadith = hadith
    }, onError: (e) {
      emit(SingleHadithError(e.toString()));
    });
    return hadith;
  }
}