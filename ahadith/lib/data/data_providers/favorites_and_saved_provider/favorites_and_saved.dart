import 'dart:math';

import 'package:ahadith/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ahadith/data/models/hadith.dart';

class FavoritesAndSavedProvider with ChangeNotifier {
  final Box _favoriteBox = Hive.box('favorites');

  FavoritesAndSavedProvider() {
    fitchFavorites();
  }

  List _favoriteIDs = [];
  final List<DetailedHadith> _favoriteItems = [];

  Set get favoriteIDs {
    fitchFavorites();
    return {..._favoriteIDs};
  }

  List get favoriteItems {
    fitchFavorites();
    return [..._favoriteItems];
  }

  void fitchFavorites() {
    _favoriteItems.clear();
    _favoriteIDs = _favoriteBox.get(0, defaultValue: []);
    for (var id in _favoriteIDs) {
      if (!_favoriteItems.any((element) => element.id == id)) {
        _favoriteItems.add(
          DetailedHadith(
            id: id,
            title: _favoriteBox.get(id)['title'],
            hadeeth: _favoriteBox.get(id)['hadeeth'],
            attribution: _favoriteBox.get(id)['attribution'],
            grade: _favoriteBox.get(id)['grade'],
            explanation: _favoriteBox.get(id)['explanation'],
            categories: _favoriteBox.get(id)['categories'],
            wordsMeanings: _favoriteBox.get(id)['wordsMeanings'] != null
                ? [
                    WordsMeanings(
                        word:
                            '${_favoriteBox.get(id)['wordsMeanings'].toString().split(',')}',
                        meaning: '')
                  ]
                : [],
            reference: _favoriteBox.get(id)['reference'],
          ),
        );
      }
    }
  }

  void addFavorite(String id, DetailedHadith hadith, String categoryTitle,
      int hadithIndex, bool fromSaved) {
    fitchFavorites();

    if (_favoriteIDs.contains(id)) return;

    _favoriteIDs.add(id);
    _favoriteBox.put(0, _favoriteIDs);

    _favoriteIDs = _favoriteBox.get(0) ?? [];

    _favoriteBox.put(
      hadith.id,
      {
        'id': hadith.id,
        'title': hadith.title,
        'hadeeth': hadith.hadeeth,
        'attribution': hadith.attribution,
        'grade': hadith.grade,
        'explanation': hadith.explanation,
        'categories': [categoryTitle, ...hadith.categories!],
        'wordsMeanings': hadith.wordsMeanings!.isNotEmpty
            ? hadith.wordsMeanings!.toList().toString()
            : null,
        'reference': fromSaved
            ? '${hadithIndex.toString()} من المحفوظات '
            : (hadithIndex + 1).toString(),
      },
    );

    fitchFavorites();

    notifyListeners();
  }

  void removeFavorite(String id, DetailedHadith hadith) {
    // _favoriteBox.clear();
    fitchFavorites();

    if (_favoriteIDs.contains(id)) {
      _favoriteIDs.remove(id);
      _favoriteBox.put(0, _favoriteIDs);

      _favoriteBox.delete(hadith.id);

      fitchFavorites();

      notifyListeners();
    }
  }

  void toggleFavorite(String id, DetailedHadith hadith, String categoryTitle,
      int hadithIndex, bool formSaved) {
    if (_favoriteIDs.contains(id)) {
      removeFavorite(id, hadith);
    } else {
      addFavorite(id, hadith, categoryTitle, hadithIndex, formSaved);
    }
    // notifyListeners();
  }

  void clearFavorites() {
    _favoriteIDs.clear();
    _favoriteBox.clear();
    notifyListeners();
  }

  bool isFavorite(String id) {
    fitchFavorites();
    return _favoriteIDs.contains(id);
  }

  int get favoriteCount {
    fitchFavorites();
    return _favoriteIDs.length;
  }

  //-------------------- Saved --------------------

  final Box _savedBox = Hive.box('saved');

  Map<String, List<DetailedHadith>> _savedCategories = {};
  List<DetailedHadith> savedAhadith = [];
  List _savedCategoriesIds = [];
  Map<String, String> _savedCategoriesTitles = {};
  List<String> _savedCategoriesTitlesList = [];

  Map<String, List<DetailedHadith>> get savedCategories {
    return {..._savedCategories};
  }

  Map<String, String> get savedCategoriesTitles {
    return {..._savedCategoriesTitles};
  }

  List<String> get savedCategoriesTitlesList {
    return [..._savedCategoriesTitlesList];
  }

  List get savedCategoriesIds {
    fitchSaved();
    return [..._savedCategoriesIds];
  }

  void addSaved(List<DetailedHadith> ahadith, Category category) {
    if (_savedBox.containsKey(category.id)) return;

    fitchSaved();

    _savedCategoriesIds.add(category.id);
    _savedBox.put(0, _savedCategoriesIds);

    List<Map<String, dynamic>> ahadithMap = turnAhadithToMaps(ahadith);

    _savedBox.put(category.id, ahadithMap);
    _savedBox.put('catName${category.id}', category.title);

    fitchSaved();

    notifyListeners();
  }

  void fitchSaved() {
    // _savedCategoriesIds.clear();
    _savedCategoriesIds = _savedBox.get(0, defaultValue: []);
    // _savedCategories.clear();

    _savedCategoriesTitlesList.clear();

    for (var id in _savedCategoriesIds) {
      _savedCategoriesTitles.putIfAbsent(id, () => _savedBox.get('catName$id'));
      _savedCategoriesTitlesList.add(_savedBox.get('catName$id'));

      List<dynamic> ahadithMap = _savedBox.get(id);
      List<DetailedHadith> ahadith = turnMapsToAhadith(ahadithMap);
      _savedCategories.putIfAbsent(id, () => ahadith);
      savedAhadith += ahadith;
    }
  }

  bool isSaved(String id) {
    return _savedBox.containsKey(id);
  }

  int get savedCount {
    return _savedCategoriesIds.length;
  }

  List<Map<String, dynamic>> turnAhadithToMaps(List<DetailedHadith> ahadith) {
    List<Map<String, dynamic>> ahadithMap = ahadith
        .map((hadith) => {
              'id': hadith.id.toString(),
              'title': hadith.title.toString(),
              'hadeeth': hadith.hadeeth.toString(),
              'attribution': hadith.attribution.toString(),
              'grade': hadith.grade.toString(),
              'explanation': hadith.explanation.toString(),
              'categories': hadith.categories,
              'wordsMeanings': hadith.wordsMeanings != null
                  ? hadith.wordsMeanings!.isNotEmpty
                      ? hadith.wordsMeanings!.toString()
                      : []
                  : [],
              'reference': hadith.reference.toString(),
            })
        .toList();
    return ahadithMap;
  }

  List<DetailedHadith> turnMapsToAhadith(List<dynamic> ahadithMap) {
    List<DetailedHadith> ahadith = ahadithMap
        .map((hadith) => DetailedHadith(
              id: hadith['id']!,
              title: hadith['title']!,
              hadeeth: hadith['hadeeth']!,
              attribution: hadith['attribution']!,
              grade: hadith['grade']!,
              explanation: hadith['explanation'] ?? [],
              categories: hadith['categories'] ?? [],
              wordsMeanings: hadith['wordsMeanings'] != null
                  ? [
                      WordsMeanings(
                          word:
                              '${hadith['wordsMeanings'].toString().split(',')}',
                          meaning: '')
                    ]
                  : [],
              reference: hadith['reference']!,
            ))
        .toList();
    return ahadith;
  }

  List<DetailedHadith> get randomAhadith {

    fitchSaved();
    List randomAhadithIds =
        _savedBox.get('randomAhadith', defaultValue: ['nawawisAhadith13']);
    List tempRandomAhadithIds = [...randomAhadithIds] ;
    List<DetailedHadith> randomAhadith = [DetailedHadith(
        id: 'nawawisAhadith13',
        title: 'من كمال الإيمان',
        hadeeth:
        'عَنْ أَبِيْ حَمْزَة أَنَسِ بنِ مَالِكٍ رَضِيَ اللهُ تَعَالَى عَنْهُ خَادِمِ رَسُوْلِ اللهِ ﷺ عَن النبي ﷺ قَالَ: (لاَ يُؤمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيْهِ مَا يُحِبُّ لِنَفْسِهِ)',
        attribution: 'رواه البخاري ومسلم',
        grade: 'صحيح.',
        explanation:
        'قوله: (لا َيُؤمِنُ أَحَدُكُمْ) أي لا يتم إيمان أحدنا، فالنفي هنا للكمال والتمام، وليس نفياً لأصل الإيمان. فإن قال قائل: ما دليلكم على هذا التأويل الذي فيه صرف الكلام عن ظاهره؟ قلنا: دليلنا على هذا أن ذلك العمل لا يخرج به الإنسان من الإيمان، ولا يعتبر مرتدّاً، وإنما هو من باب النصيحة، فيكون النفي هنا نفياً لكمال الإيمان. فإن قال قائل: ألستم تنكرون على أهل التأويل تأويلهم؟ فالجواب: نحن لا ننكر على أهل التأويل تأويلهم، إنما ننكر على أهل التأويل تأويلهم الذي لا دليل عليه، لأنه إذا لم يكن عليه دليلٌ صار تحريفاً وليس تأويلاً، أما التأويل الذي دلّ عليه الدليل فإنه يعتبر من تفسير الكلام، كما قال النبي ﷺ في عبد الله بن عباس رضي الله عنهما: "اللَّهُمَّ فَقِّههُ فِي الدِّيْنِ وَعَلِّمْهُ التَّأوِيْلَ" فإن قال قائل: في قول الله تعالى: (فَإِذَا قَرَأْتَ الْقُرْآنَ فَاسْتَعِذْ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ) المراد به: إذا أردت قراءة القرآن، فهل يعتبر هذا تأويلاً مذموماً، أو تأويلاً صحيحاً؟ والجواب: هذا تأويل صحيح، لأنه دلّ عليه الدليل من فعل النبي ﷺ ، فقد كان ﷺ يتعوّذ عند القراءة لا في آخر القراءة . وعليه فلا ننكر التأويل مطلقاً، إنما ننكر التأويل الذي لا دليل عليه ونسميه تحريفاً. (لاَ يُؤمِنُ أَحَدُكُمْ) الإيمان في اللغة هو: الإقرار المستلزم للقبول والإذعان والإيمان وهو مطابق للشرع وقيل: هو التصديق وفيه نظر؛ لأنه يقال: آمنت بكذا وصدقت فلاناً ولا يقال: آمنت فلاناً. فالإيمان في اللغة حقيقة : إقرار القلب بما يرد عليه، وليس التصديق. وقد يرد الإيمان بمعنى التصديق بقرينة مثل قوله تعالى: (فَآمَنَ لَهُ لُوطٌ) على أحد القولين مع أنه يمكن أن يقال: فآمن له لوط أي انقاد له - أي إبراهيم - وصدّق دعوته. أما الإيمان في الشرع فهوكما سبق في تعريفه في اللغة. فمن أقرّ بدون قبول وإذعان فليس بمؤمن، وعلى هذا فاليهود والنصارى اليوم ليسوا بمؤمنين لأنهم لم يقبلوا دين الإسلام ولم يذعنوا. ومحل الإيمان: القلب واللسان والجوارح، فالإيمان يكون بالقلب، ويكون باللسان، ويكون بالجوارح، أي أن قول اللسان يسمى إيماناً، وعمل الجوارح يسمى إيماناً، والدليل: قول الله عزّ وجل: (وَمَا كَانَ اللَّهُ لِيُضِيعَ إِيمَانَكُمْ) قال المفسّرون: إيمانكم: أي صلاتكم إلى بيت المقدس، وقال النبي ﷺ : (الإِيْمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً فَأَعْلاهَا قَوْلُ لاَ إِلَهَ إِلاَّ الله، وأدنْاهَا إِمَاطَةُ الأذى عَنِ الطَّرِيْقِ وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيْمَانِ) أعلاها قول: لا إله إلا الله، هذا قول اللسان. وأدناها : إماطة الأذى عن الطريق وهذا فعل الجوارح، والحياء عمل القلب. وأما القول بأن الإيمان محلّه القلب فقط، وأن من أقرّ فقد آمن فهذا غلط ولا يصحّ. وقوله: (حَتَّى يُحَبَّ) (حتى) هذه للغاية، يعني: إلى أن "يُحَبَّ لأَخِيْه" والمحبة: لا تحتاج إلى تفسير، ولا يزيد تفسيرها إلا إشكالاً وخفاءً، فالمحبة هي المحبة، ولا تفسَّر بأبين من لفظها. وقوله: (لأَخِيْهِ) أي المؤمن (مَا يُحبُّ لِنَفْسِهِ) من خير ودفع شر ودفاع عن العرض وغير ذلك.',
        categories: ['الاحاديث الاربعون النووية'],
        wordsMeanings: [],
        reference: 'المصدر: الاحاديث الاربعون النووية')];
    savedAhadith.forEach((element) {
      if (!randomAhadith.contains(element) && randomAhadithIds.contains(element.id) && tempRandomAhadithIds.contains(element.id)) {
        tempRandomAhadithIds.remove(element.id);
        randomAhadith.add(element);
      }
    });
    return randomAhadith;
  }

  DetailedHadith get randomHadith {
    if (didDateChange()) {
      fitchSaved();

      if (savedAhadith.isEmpty || !_savedBox.containsKey('randomAhadith')) {
        _savedBox.put('randomAhadith', ['nawawisAhadith13']);
        return DetailedHadith(
            id: 'nawawisAhadith13',
            title: 'من كمال الإيمان',
            hadeeth:
                'عَنْ أَبِيْ حَمْزَة أَنَسِ بنِ مَالِكٍ رَضِيَ اللهُ تَعَالَى عَنْهُ خَادِمِ رَسُوْلِ اللهِ ﷺ عَن النبي ﷺ قَالَ: (لاَ يُؤمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيْهِ مَا يُحِبُّ لِنَفْسِهِ)',
            attribution: 'رواه البخاري ومسلم',
            grade: 'صحيح.',
            explanation:
                'قوله: (لا َيُؤمِنُ أَحَدُكُمْ) أي لا يتم إيمان أحدنا، فالنفي هنا للكمال والتمام، وليس نفياً لأصل الإيمان. فإن قال قائل: ما دليلكم على هذا التأويل الذي فيه صرف الكلام عن ظاهره؟ قلنا: دليلنا على هذا أن ذلك العمل لا يخرج به الإنسان من الإيمان، ولا يعتبر مرتدّاً، وإنما هو من باب النصيحة، فيكون النفي هنا نفياً لكمال الإيمان. فإن قال قائل: ألستم تنكرون على أهل التأويل تأويلهم؟ فالجواب: نحن لا ننكر على أهل التأويل تأويلهم، إنما ننكر على أهل التأويل تأويلهم الذي لا دليل عليه، لأنه إذا لم يكن عليه دليلٌ صار تحريفاً وليس تأويلاً، أما التأويل الذي دلّ عليه الدليل فإنه يعتبر من تفسير الكلام، كما قال النبي ﷺ في عبد الله بن عباس رضي الله عنهما: "اللَّهُمَّ فَقِّههُ فِي الدِّيْنِ وَعَلِّمْهُ التَّأوِيْلَ" فإن قال قائل: في قول الله تعالى: (فَإِذَا قَرَأْتَ الْقُرْآنَ فَاسْتَعِذْ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ) المراد به: إذا أردت قراءة القرآن، فهل يعتبر هذا تأويلاً مذموماً، أو تأويلاً صحيحاً؟ والجواب: هذا تأويل صحيح، لأنه دلّ عليه الدليل من فعل النبي ﷺ ، فقد كان ﷺ يتعوّذ عند القراءة لا في آخر القراءة . وعليه فلا ننكر التأويل مطلقاً، إنما ننكر التأويل الذي لا دليل عليه ونسميه تحريفاً. (لاَ يُؤمِنُ أَحَدُكُمْ) الإيمان في اللغة هو: الإقرار المستلزم للقبول والإذعان والإيمان وهو مطابق للشرع وقيل: هو التصديق وفيه نظر؛ لأنه يقال: آمنت بكذا وصدقت فلاناً ولا يقال: آمنت فلاناً. فالإيمان في اللغة حقيقة : إقرار القلب بما يرد عليه، وليس التصديق. وقد يرد الإيمان بمعنى التصديق بقرينة مثل قوله تعالى: (فَآمَنَ لَهُ لُوطٌ) على أحد القولين مع أنه يمكن أن يقال: فآمن له لوط أي انقاد له - أي إبراهيم - وصدّق دعوته. أما الإيمان في الشرع فهوكما سبق في تعريفه في اللغة. فمن أقرّ بدون قبول وإذعان فليس بمؤمن، وعلى هذا فاليهود والنصارى اليوم ليسوا بمؤمنين لأنهم لم يقبلوا دين الإسلام ولم يذعنوا. ومحل الإيمان: القلب واللسان والجوارح، فالإيمان يكون بالقلب، ويكون باللسان، ويكون بالجوارح، أي أن قول اللسان يسمى إيماناً، وعمل الجوارح يسمى إيماناً، والدليل: قول الله عزّ وجل: (وَمَا كَانَ اللَّهُ لِيُضِيعَ إِيمَانَكُمْ) قال المفسّرون: إيمانكم: أي صلاتكم إلى بيت المقدس، وقال النبي ﷺ : (الإِيْمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً فَأَعْلاهَا قَوْلُ لاَ إِلَهَ إِلاَّ الله، وأدنْاهَا إِمَاطَةُ الأذى عَنِ الطَّرِيْقِ وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيْمَانِ) أعلاها قول: لا إله إلا الله، هذا قول اللسان. وأدناها : إماطة الأذى عن الطريق وهذا فعل الجوارح، والحياء عمل القلب. وأما القول بأن الإيمان محلّه القلب فقط، وأن من أقرّ فقد آمن فهذا غلط ولا يصحّ. وقوله: (حَتَّى يُحَبَّ) (حتى) هذه للغاية، يعني: إلى أن "يُحَبَّ لأَخِيْه" والمحبة: لا تحتاج إلى تفسير، ولا يزيد تفسيرها إلا إشكالاً وخفاءً، فالمحبة هي المحبة، ولا تفسَّر بأبين من لفظها. وقوله: (لأَخِيْهِ) أي المؤمن (مَا يُحبُّ لِنَفْسِهِ) من خير ودفع شر ودفاع عن العرض وغير ذلك.',
            categories: ['الاحاديث الاربعون النووية'],
            wordsMeanings: [],
            reference: 'المصدر: الاحاديث الاربعون النووية');
      }

      int index = Random().nextInt(savedAhadith.length);
      var hadith = savedAhadith[index];

      var randomAhadith = _savedBox.get('randomAhadith', defaultValue: []);

      while (randomAhadith.contains(hadith.id)) {
        index = Random().nextInt(savedAhadith.length);
        hadith = savedAhadith[index];
      }
      randomAhadith.add(hadith.id);

      _savedBox.put('randomAhadith', randomAhadith);
      _savedBox.put('randomHadith', {
        'id': hadith.id.toString(),
        'title': hadith.title.toString(),
        'hadeeth': hadith.hadeeth.toString(),
        'attribution': hadith.attribution.toString(),
        'grade': hadith.grade.toString(),
        'explanation': hadith.explanation.toString(),
        'categories': hadith.categories,
        'wordsMeanings': hadith.wordsMeanings != null
            ? hadith.wordsMeanings!.isNotEmpty
                ? hadith.wordsMeanings!.toString()
                : []
            : [],
        'reference': hadith.reference.toString(),
      });
      return hadith;
    }
    if (!_savedBox.containsKey('randomHadith')) {
      _savedBox.put('randomHadith', {
        'id': 'nawawisAhadith13',
        'title': 'من كمال الإيمان',
        'hadeeth':
            'عَنْ أَبِيْ حَمْزَة أَنَسِ بنِ مَالِكٍ رَضِيَ اللهُ تَعَالَى عَنْهُ خَادِمِ رَسُوْلِ اللهِ ﷺ عَن النبي ﷺ قَالَ: (لاَ يُؤمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيْهِ مَا يُحِبُّ لِنَفْسِهِ)',
        'attribution': 'رواه البخاري ومسلم',
        'grade': 'صحيح.',
        'explanation':
            'قوله: (لا َيُؤمِنُ أَحَدُكُمْ) أي لا يتم إيمان أحدنا، فالنفي هنا للكمال والتمام، وليس نفياً لأصل الإيمان. فإن قال قائل: ما دليلكم على هذا التأويل الذي فيه صرف الكلام عن ظاهره؟ قلنا: دليلنا على هذا أن ذلك العمل لا يخرج به الإنسان من الإيمان، ولا يعتبر مرتدّاً، وإنما هو من باب النصيحة، فيكون النفي هنا نفياً لكمال الإيمان. فإن قال قائل: ألستم تنكرون على أهل التأويل تأويلهم؟ فالجواب: نحن لا ننكر على أهل التأويل تأويلهم، إنما ننكر على أهل التأويل تأويلهم الذي لا دليل عليه، لأنه إذا لم يكن عليه دليلٌ صار تحريفاً وليس تأويلاً، أما التأويل الذي دلّ عليه الدليل فإنه يعتبر من تفسير الكلام، كما قال النبي ﷺ في عبد الله بن عباس رضي الله عنهما: "اللَّهُمَّ فَقِّههُ فِي الدِّيْنِ وَعَلِّمْهُ التَّأوِيْلَ" فإن قال قائل: في قول الله تعالى: (فَإِذَا قَرَأْتَ الْقُرْآنَ فَاسْتَعِذْ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ) المراد به: إذا أردت قراءة القرآن، فهل يعتبر هذا تأويلاً مذموماً، أو تأويلاً صحيحاً؟ والجواب: هذا تأويل صحيح، لأنه دلّ عليه الدليل من فعل النبي ﷺ ، فقد كان ﷺ يتعوّذ عند القراءة لا في آخر القراءة . وعليه فلا ننكر التأويل مطلقاً، إنما ننكر التأويل الذي لا دليل عليه ونسميه تحريفاً. (لاَ يُؤمِنُ أَحَدُكُمْ) الإيمان في اللغة هو: الإقرار المستلزم للقبول والإذعان والإيمان وهو مطابق للشرع وقيل: هو التصديق وفيه نظر؛ لأنه يقال: آمنت بكذا وصدقت فلاناً ولا يقال: آمنت فلاناً. فالإيمان في اللغة حقيقة : إقرار القلب بما يرد عليه، وليس التصديق. وقد يرد الإيمان بمعنى التصديق بقرينة مثل قوله تعالى: (فَآمَنَ لَهُ لُوطٌ) على أحد القولين مع أنه يمكن أن يقال: فآمن له لوط أي انقاد له - أي إبراهيم - وصدّق دعوته. أما الإيمان في الشرع فهوكما سبق في تعريفه في اللغة. فمن أقرّ بدون قبول وإذعان فليس بمؤمن، وعلى هذا فاليهود والنصارى اليوم ليسوا بمؤمنين لأنهم لم يقبلوا دين الإسلام ولم يذعنوا. ومحل الإيمان: القلب واللسان والجوارح، فالإيمان يكون بالقلب، ويكون باللسان، ويكون بالجوارح، أي أن قول اللسان يسمى إيماناً، وعمل الجوارح يسمى إيماناً، والدليل: قول الله عزّ وجل: (وَمَا كَانَ اللَّهُ لِيُضِيعَ إِيمَانَكُمْ) قال المفسّرون: إيمانكم: أي صلاتكم إلى بيت المقدس، وقال النبي ﷺ : (الإِيْمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً فَأَعْلاهَا قَوْلُ لاَ إِلَهَ إِلاَّ الله، وأدنْاهَا إِمَاطَةُ الأذى عَنِ الطَّرِيْقِ وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيْمَانِ) أعلاها قول: لا إله إلا الله، هذا قول اللسان. وأدناها : إماطة الأذى عن الطريق وهذا فعل الجوارح، والحياء عمل القلب. وأما القول بأن الإيمان محلّه القلب فقط، وأن من أقرّ فقد آمن فهذا غلط ولا يصحّ. وقوله: (حَتَّى يُحَبَّ) (حتى) هذه للغاية، يعني: إلى أن "يُحَبَّ لأَخِيْه" والمحبة: لا تحتاج إلى تفسير، ولا يزيد تفسيرها إلا إشكالاً وخفاءً، فالمحبة هي المحبة، ولا تفسَّر بأبين من لفظها. وقوله: (لأَخِيْهِ) أي المؤمن (مَا يُحبُّ لِنَفْسِهِ) من خير ودفع شر ودفاع عن العرض وغير ذلك.',
        'categories': ['الاحاديث الاربعون النووية'],
        'wordsMeanings': [],
        'reference': 'المصدر: الاحاديث الاربعون النووية'
      });
    }
    final hadithMap = _savedBox.get('randomHadith', defaultValue: {
      // 'id': 'nawawisAhadith13',
      // 'title': 'من كمال الإيمان',
      // 'hadeeth':
      //     'عَنْ أَبِيْ حَمْزَة أَنَسِ بنِ مَالِكٍ رَضِيَ اللهُ تَعَالَى عَنْهُ خَادِمِ رَسُوْلِ اللهِ ﷺ عَن النبي ﷺ قَالَ: (لاَ يُؤمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيْهِ مَا يُحِبُّ لِنَفْسِهِ)',
      // 'attribution': 'رواه البخاري ومسلم',
      // 'grade': 'صحيح.',
      // 'explanation':
      //     'قوله: (لا َيُؤمِنُ أَحَدُكُمْ) أي لا يتم إيمان أحدنا، فالنفي هنا للكمال والتمام، وليس نفياً لأصل الإيمان. فإن قال قائل: ما دليلكم على هذا التأويل الذي فيه صرف الكلام عن ظاهره؟ قلنا: دليلنا على هذا أن ذلك العمل لا يخرج به الإنسان من الإيمان، ولا يعتبر مرتدّاً، وإنما هو من باب النصيحة، فيكون النفي هنا نفياً لكمال الإيمان. فإن قال قائل: ألستم تنكرون على أهل التأويل تأويلهم؟ فالجواب: نحن لا ننكر على أهل التأويل تأويلهم، إنما ننكر على أهل التأويل تأويلهم الذي لا دليل عليه، لأنه إذا لم يكن عليه دليلٌ صار تحريفاً وليس تأويلاً، أما التأويل الذي دلّ عليه الدليل فإنه يعتبر من تفسير الكلام، كما قال النبي ﷺ في عبد الله بن عباس رضي الله عنهما: "اللَّهُمَّ فَقِّههُ فِي الدِّيْنِ وَعَلِّمْهُ التَّأوِيْلَ" فإن قال قائل: في قول الله تعالى: (فَإِذَا قَرَأْتَ الْقُرْآنَ فَاسْتَعِذْ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ) المراد به: إذا أردت قراءة القرآن، فهل يعتبر هذا تأويلاً مذموماً، أو تأويلاً صحيحاً؟ والجواب: هذا تأويل صحيح، لأنه دلّ عليه الدليل من فعل النبي ﷺ ، فقد كان ﷺ يتعوّذ عند القراءة لا في آخر القراءة . وعليه فلا ننكر التأويل مطلقاً، إنما ننكر التأويل الذي لا دليل عليه ونسميه تحريفاً. (لاَ يُؤمِنُ أَحَدُكُمْ) الإيمان في اللغة هو: الإقرار المستلزم للقبول والإذعان والإيمان وهو مطابق للشرع وقيل: هو التصديق وفيه نظر؛ لأنه يقال: آمنت بكذا وصدقت فلاناً ولا يقال: آمنت فلاناً. فالإيمان في اللغة حقيقة : إقرار القلب بما يرد عليه، وليس التصديق. وقد يرد الإيمان بمعنى التصديق بقرينة مثل قوله تعالى: (فَآمَنَ لَهُ لُوطٌ) على أحد القولين مع أنه يمكن أن يقال: فآمن له لوط أي انقاد له - أي إبراهيم - وصدّق دعوته. أما الإيمان في الشرع فهوكما سبق في تعريفه في اللغة. فمن أقرّ بدون قبول وإذعان فليس بمؤمن، وعلى هذا فاليهود والنصارى اليوم ليسوا بمؤمنين لأنهم لم يقبلوا دين الإسلام ولم يذعنوا. ومحل الإيمان: القلب واللسان والجوارح، فالإيمان يكون بالقلب، ويكون باللسان، ويكون بالجوارح، أي أن قول اللسان يسمى إيماناً، وعمل الجوارح يسمى إيماناً، والدليل: قول الله عزّ وجل: (وَمَا كَانَ اللَّهُ لِيُضِيعَ إِيمَانَكُمْ) قال المفسّرون: إيمانكم: أي صلاتكم إلى بيت المقدس، وقال النبي ﷺ : (الإِيْمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً فَأَعْلاهَا قَوْلُ لاَ إِلَهَ إِلاَّ الله، وأدنْاهَا إِمَاطَةُ الأذى عَنِ الطَّرِيْقِ وَالحَيَاءُ شُعْبَةٌ مِنَ الإِيْمَانِ) أعلاها قول: لا إله إلا الله، هذا قول اللسان. وأدناها : إماطة الأذى عن الطريق وهذا فعل الجوارح، والحياء عمل القلب. وأما القول بأن الإيمان محلّه القلب فقط، وأن من أقرّ فقد آمن فهذا غلط ولا يصحّ. وقوله: (حَتَّى يُحَبَّ) (حتى) هذه للغاية، يعني: إلى أن "يُحَبَّ لأَخِيْه" والمحبة: لا تحتاج إلى تفسير، ولا يزيد تفسيرها إلا إشكالاً وخفاءً، فالمحبة هي المحبة، ولا تفسَّر بأبين من لفظها. وقوله: (لأَخِيْهِ) أي المؤمن (مَا يُحبُّ لِنَفْسِهِ) من خير ودفع شر ودفاع عن العرض وغير ذلك.',
      // 'categories': ['الاحاديث الاربعون النووية'],
      // 'wordsMeanings': [],
      // 'reference': 'المصدر: الاحاديث الاربعون النووية'
    });

    final hadith = DetailedHadith(
      id: hadithMap['id']!,
      title: hadithMap['title']!,
      hadeeth: hadithMap['hadeeth']!,
      attribution: hadithMap['attribution']!,
      grade: hadithMap['grade']!,
      explanation: hadithMap['explanation'] ?? [],
      categories: hadithMap['categories'] ?? [],
      wordsMeanings: hadithMap['wordsMeanings'] != null
          ? [
              WordsMeanings(
                  word: '${hadithMap['wordsMeanings'].toString().split(',')}',
                  meaning: '')
            ]
          : [],
      reference: hadithMap['reference']!,
    );
    return hadith;
  }

  bool didDateChange() {
    if (!_savedBox.containsKey('date')) {
      _savedBox.put('date', DateTime.now());
      return true;
    }
    var date = DateTime.now();
    final savedDate = _savedBox.get('date');

    if (date.day != savedDate.day ||
        date.month != savedDate.month ||
        date.year != savedDate.year) {
      _savedBox.put('date', DateTime.now());
      return true;
    }
    return false;
  }
}
