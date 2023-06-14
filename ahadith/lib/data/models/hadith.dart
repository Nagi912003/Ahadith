class Hadith {
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

  Hadith(
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

  Hadith.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['hadeeth'] = this.hadeeth;
    data['attribution'] = this.attribution;
    data['grade'] = this.grade;
    data['explanation'] = this.explanation;
    data['hints'] = this.hints;
    data['categories'] = this.categories;
    data['translations'] = this.translations;
    if (this.wordsMeanings != null) {
      data['words_meanings'] =
          this.wordsMeanings!.map((v) => v.toJson()).toList();
    }
    data['reference'] = this.reference;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['meaning'] = this.meaning;
    return data;
  }
}
