import 'package:bloc/bloc.dart';

import '../../data/repositories/single_hadith_repository.dart';
import 'package:ahadith/data/models/hadith.dart';

import 'single_hadith_state.dart';

class SingleHadithCubit extends Cubit<SingleHadithState> {

  final SingleHadithRepository singleHadithRepository;
  DetailedHadith hadith = DetailedHadith();
  List<DetailedHadith> hadiths = [];

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

  List<DetailedHadith> getHadiths({required List<String> hadithIds}) {
    List<DetailedHadith> hadiths = [];
    emit(SingleHadithsLoading());
    singleHadithRepository.getHadiths(hadithIds: hadithIds).then((hadiths) => {
      if(hadiths.isEmpty){
        emit(SingleHadithsError('Ahadeeth list came empty')),
      }else{
      emit(SingleHadithsLoaded(hadiths)),
      this.hadiths = hadiths
      },
    }, onError: (e) {
      emit(SingleHadithsError(e.toString()));
    });
    return hadiths;
  }
}