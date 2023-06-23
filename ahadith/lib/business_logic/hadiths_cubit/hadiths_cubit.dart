import 'package:bloc/bloc.dart';

import '../../data/models/hadith.dart';

import '../../data/repositories/hadiths_repository.dart';
import 'hadiths_state.dart';

class HadithsCubit extends Cubit<HadithsState> {

  final HadithsRepository hadithsRepository;
  List<Hadith> hadiths = [];

  HadithsCubit(this.hadithsRepository) : super(HadithsInitial());

  List<Hadith>getAllHadith({required String categoryId, String page = '1', String perPage = '20'}) {
    emit(HadithsLoading());
    if(page == '1'){
      hadiths = [];
    }
    hadithsRepository.getAllHadiths(categoryId: categoryId, page: page, perPage: perPage).then((hadiths) => {
      if(page == '1'){
        this.hadiths = hadiths,
        emit(HadithsLoaded(hadiths)),
      }else if (hadiths.isEmpty){
        emit(HadithsNoMore(this.hadiths)),
      }else{
        this.hadiths += hadiths,
        emit(HadithsLoadedMore(hadiths)),
      }
    },
    onError: (e) {
      emit(HadithsError(e.toString()));
    });
    return hadiths;
  }
}