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
    if (json['hints'] != null) {
      hints = json['hints'].cast<String>()??[];
    }else{
      hints = null;
    }
    if (json['categories'] != null) {
      categories = json['categories'].cast<String>()??[];
    }else{
      categories = null;
    }
    if (json['translations'] != null) {
      translations = json['translations'].cast<String>()??[];
    }else{
      translations = null;
    }
    if (json['words_meanings'] != null) {
      wordsMeanings = <WordsMeanings>[];
      json['words_meanings'].forEach((v) {
        wordsMeanings!.add(WordsMeanings.fromJson(v));
      });
    }
    reference = json['reference'];
  }

  @override
  String toString() {
    return 'id:$id\ntitle:$title\nexplanation:$explanation\nhadeeth:$hadeeth\nattribution:$attribution\ngrade:$grade\nhints:$hints\ncategories:$categories\ntranslations:$translations\nwordsMeanings:$wordsMeanings\nreference:$reference\n\n';
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
