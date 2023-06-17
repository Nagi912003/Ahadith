class Hadith {
  String? id;
  String? title;
  List<String>? translations;

  Hadith(
      {this.id,
        this.title,
        this.translations,});

  Hadith.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    translations = json['translations'].cast<String>();
    }
}
class DetailedHadith {
  String? id;
  String? title;
  String? hadeeth;
  String? attribution;
  String? grade;
  String? explanation;
  List<String>? hints;
  List<String>? categories;
  List<String>? translations;
  List<WordsMeanings>? wordsMeanings;
  String? reference;

  DetailedHadith(
      {this.id,
        this.title,
        this.hadeeth,
        this.attribution,
        this.grade,
        this.explanation,
        this.hints,
        this.categories,
        this.translations,
        this.wordsMeanings,
        this.reference});

  DetailedHadith.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    hadeeth = json['hadeeth'];
    attribution = json['attribution'];
    grade = json['grade'];
    explanation = json['explanation'];
    hints = json['hints'].cast<String>();
    categories = json['categories'].cast<String>();
    translations = json['translations'].cast<String>();
    if (json['words_meanings'] != null) {
      wordsMeanings = <WordsMeanings>[];
      json['words_meanings'].forEach((v) {
        wordsMeanings!.add(WordsMeanings.fromJson(v));
      });
    }
    reference = json['reference'];
  }
}

class WordsMeanings {
  String? word;
  String? meaning;

  WordsMeanings({this.word, this.meaning});

  WordsMeanings.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    meaning = json['meaning'];
  }

  @override
  String toString() {
    return '$word: $meaning \n';
  }
}
