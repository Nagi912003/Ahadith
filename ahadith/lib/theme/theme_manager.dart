import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeManager with ChangeNotifier {
  final Box _savedBox = Hive.box('saved');

  ThemeManager._private() {
    // Private constructor
    if (!_savedBox.containsKey('themeMode')) {
      _savedBox.put('themeMode', 5);
      toggleBackGroundImage(_savedBox.get('themeMode'));
    } else {
      toggleBackGroundImage(_savedBox.get('themeMode'));
    }
    if (!_savedBox.containsKey('themeFontSize')) {
      _savedBox.put('themeFontSize', 0);
    } else {
      toggleFontSize(double.parse(_savedBox.get('themeFontSize').toString()));
    }
  }

  static final ThemeManager _instance = ThemeManager._private();

  factory ThemeManager() {
    return _instance;
  }

  String bgImage = 'assets/images/watercolor.png';
  int mode = 1;
  double fontSize = 0;
  double addedFontSize = 0;
  Color appPrimaryColor = Colors.deepPurple;
  Color appPrimaryColor200 = Colors.deepPurple[200]!;
  Color appPrimaryColorInverse = Colors.deepPurple[200]!;

  void setBackGroundImage(String imagePath) {
    bgImage = imagePath;
    notifyListeners();
  }

  void toggleBackGroundImage(int mode) {
    switch (mode) {
      case 1:
        _savedBox.put('themeMode', 1);
        this.mode = 1;
        appPrimaryColor = Colors.deepPurple[200]!;
        appPrimaryColor200 = Colors.deepPurple[100]!;
        appPrimaryColorInverse = Colors.deepPurple[200]!;
        bgImage = 'assets/images/watercolor.png';
        break;
      case 2:
        _savedBox.put('themeMode', 2);
        this.mode = 2;
        appPrimaryColor = Colors.deepPurple;
        appPrimaryColor200 = Colors.deepPurple[200]!;
        appPrimaryColorInverse = Colors.deepPurple;
        bgImage = 'assets/images/watercolor-p.png';
        break;
      case 3:
        _savedBox.put('themeMode', 3);
        this.mode = 3;
        appPrimaryColor = Colors.indigo[200]!;
        appPrimaryColor200 = Colors.indigo[100]!;
        appPrimaryColorInverse = Colors.indigo;
        bgImage = 'assets/images/watercolor-off.png';
        break;
      case 4:
        _savedBox.put('themeMode', 4);
        this.mode = 4;
        appPrimaryColor = Colors.blueGrey;
        appPrimaryColor200 = Colors.blueGrey[200]!;
        appPrimaryColorInverse = Colors.blueGrey;
        bgImage = 'assets/images/watercolor-b.png';
        break;
      case 5:
        _savedBox.put('themeMode', 5);
        this.mode = 5;
        appPrimaryColor = Colors.green[200]!;
        appPrimaryColor200 = Colors.green[100]!;
        appPrimaryColorInverse = Colors.red;
        bgImage = 'assets/images/watercolor-g.png';
        break;
      case 7:
        _savedBox.put('themeMode', 7);
        this.mode = 7;
        appPrimaryColor = Colors.blue;
        appPrimaryColor200 = Colors.blue[300]!;
        appPrimaryColorInverse = Colors.red;
        bgImage = 'assets/images/watercolor-bw.png';
        break;
      case 8:
        _savedBox.put('themeMode', 8);
        this.mode = 8;
        appPrimaryColor = Colors.grey;
        appPrimaryColor200 = Colors.grey;
        appPrimaryColorInverse = Colors.grey;
        bgImage = 'assets/images/watercolor-grey.png';
        break;
      default:
        this.mode = 1;
        appPrimaryColor = Colors.deepPurple[200]!;
        appPrimaryColor200 = Colors.deepPurple[100]!;
        appPrimaryColorInverse = Colors.deepPurple[200]!;
        bgImage = 'assets/images/watercolor.png';
    }
    notifyListeners();
  }

  void toggleFontSize(double fontSize) {
    this.fontSize = fontSize;
    switch (fontSize) {
      case -10:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -12.5;
        break;
      case -9:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -22.5;
        break;
      case -8:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -20;
        break;
      case -7:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -17.5;
        break;
      case -6:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -15;
        break;
      case -5:
        _savedBox.put('themeFontSize', -5);
        addedFontSize = -12.5;
        break;
      case -4:
        _savedBox.put('themeFontSize', -4);
        addedFontSize = -10;
        break;
      case -3:
        _savedBox.put('themeFontSize', -3);
        addedFontSize = -7.5;
        break;
      case -2:
        _savedBox.put('themeFontSize', -2);
        addedFontSize = -5;
        break;
      case -1:
        _savedBox.put('themeFontSize', -1);
        addedFontSize = -2.5;
        break;
      case 0:
        _savedBox.put('themeFontSize', 0);
        addedFontSize = 0;
        break;
      case 1:
        _savedBox.put('themeFontSize', 1);
        addedFontSize = 2.5;
        break;
      case 2:
        _savedBox.put('themeFontSize', 2);
        addedFontSize = 5;
        break;
      case 3:
        _savedBox.put('themeFontSize', 3);
        addedFontSize = 7.5;
        break;
      case 4:
        _savedBox.put('themeFontSize', 4);
        addedFontSize = 10;
        break;
      case 5:
        _savedBox.put('themeFontSize', 5);
        addedFontSize = 12.5;
        break;
      case 6:
        _savedBox.put('themeFontSize', 6);
        addedFontSize = 17.5;
        break;
      case 7:
        _savedBox.put('themeFontSize', 7);
        addedFontSize = 22.5;
        break;
      case 8:
        _savedBox.put('themeFontSize', 7);
        addedFontSize = 25;
        break;
      case 9:
        _savedBox.put('themeFontSize', 7);
        addedFontSize = 27.5;
        break;
      case 10:
        _savedBox.put('themeFontSize', 7);
        addedFontSize = 32.5;
        break;
      default:
        this.fontSize = 0;
        addedFontSize = 0;
    }
    notifyListeners();
  }
}
