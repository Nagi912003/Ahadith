import 'dart:math';

class InvertedIndex {
  Map<String, List<Posting>> index = {};
  List<int> docLengths = [];
  int numDocs  = 0;

  InvertedIndex() {
    index = {};
  }

  void buildIndex(List<String> documents) {
    numDocs = documents.length;
    docLengths = List<int>.filled(numDocs, 0);

    for (int docId = 0; docId < numDocs; docId++) {
      // List<String> words = documents[docId].split(RegExp(r'\W+'));    ///for english
      List<String> words = documents[docId].split(RegExp(r'[^\p{L}\p{N}_]+', unicode: true));  ///for arabic
      //print('docId: $docId, words: $words');
      for (String word in words) {
        word = word.toLowerCase();

        List<Posting> postings = index[word] ?? [];
        Posting? lastPosting = postings.isEmpty ? null : postings.last;

        if (lastPosting == null || lastPosting.docId != docId) {
          postings.add(Posting(docId, 1));
        } else {
          lastPosting.termFreq++;
        }

        index[word] = postings;
        docLengths[docId]++;
      }
    }
  }

  List<Ranking> rank(String query, int k) {
    // List<String> queryTerms = query.split(RegExp(r'\W+'));  ///for english
    List<String> queryTerms = query.split(RegExp(r'[^\p{L}\p{N}_]+', unicode: true));  ///for arabic
    Map<int, double> scores = {};

    for (String term in queryTerms) {
      // term = term.toLowerCase();
      List<Posting>? postings = index[term];

      if (postings != null) {
        double idf = log(numDocs / postings.length);

        for (Posting posting in postings) {
          double tfidf = (1 + log(posting.termFreq)) * idf;
          double score = scores[posting.docId] ?? 0.0;
          score += tfidf;
          scores[posting.docId] = score;
        }
      }
    }

    for (int docId in scores.keys) {
      double tfidfSum = scores[docId]!;
      double length = docLengths[docId].toDouble();
      double normalizedScore = tfidfSum / length;
      scores[docId] = normalizedScore;
    }

    List<Ranking> rankings = scores.entries.map((entry) {
      return Ranking(entry.key, entry.value);
    }).toList();

    rankings.sort((a, b) => b.compareTo(a));
    return rankings.sublist(0, min(k, rankings.length));
  }
}

class Posting {
  int docId;
  int termFreq;

  Posting(this.docId, this.termFreq);
}

class Ranking implements Comparable<Ranking> {
  int docId;
  double score;

  Ranking(this.docId, this.score);

  @override
  int compareTo(Ranking other) {
    return score.compareTo(other.score);
  }
}

// void main() {
//   List<String> documents = [
//     'This is the first document',
//     'This document is the second document',
//     'And this is the third one',
//     'Is this the first document?',
//     'This is the best',
//     'This is the best American restaurant',
//     'The best food in town',
//     'I love this restaurant',
//     'Restaurant reviews',
//     'American cuisine'
//   ];
//
//   InvertedIndex index = InvertedIndex();
//   index.buildIndex(documents);
//
//   String query = 'the best the best American restaurant';
//   int k = 10;
//
//   List<Ranking> rankings = index.rank(query, k);
//   for (Ranking ranking in rankings) {
//     print('Document: "${documents.elementAt(ranking.docId)}" has a similarity score of ${ranking.score.toStringAsFixed(2)}');
//   }
// }