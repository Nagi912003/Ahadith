import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeManager with ChangeNotifier {
    final Box _savedBox = Hive.box('saved');
    ThemeManager(){
      if(!_savedBox.containsKey('themeMode')){
        _savedBox.put('themeMode', 1);
      }else{
        toggleBackGroundImage(_savedBox.get('themeMode'));
      }
    }

    String bgImage = 'assets/images/watercolor.png';
    int mode = 1;
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
          appPrimaryColor = Colors.deepPurple[200]!;
          appPrimaryColor200 = Colors.deepPurple[100]!;
          appPrimaryColorInverse = Colors.deepPurple[200]!;
          bgImage = 'assets/images/watercolor.png';
          break;
        case 2:
          _savedBox.put('themeMode', 2);
          appPrimaryColor = Colors.deepPurple;
          appPrimaryColor200 = Colors.deepPurple[200]!;
          appPrimaryColorInverse = Colors.deepPurple;
          bgImage = 'assets/images/watercolor-p.png';
          break;
        case 3:
          _savedBox.put('themeMode', 3);
          appPrimaryColor = Colors.indigo[200]!;
          appPrimaryColor200 = Colors.indigo[100]!;
          appPrimaryColorInverse = Colors.indigo;
          bgImage = 'assets/images/watercolor-off.png';
          break;
        case 4:
          _savedBox.put('themeMode', 4);
          appPrimaryColor = Colors.blueGrey;
          appPrimaryColor200 = Colors.blueGrey[200]!;
          appPrimaryColorInverse = Colors.blueGrey;
          bgImage = 'assets/images/watercolor-b.png';
          break;
        case 5:
          _savedBox.put('themeMode', 5);
          appPrimaryColor = Colors.green[200]!;
          appPrimaryColor200 = Colors.green[100]!;
          appPrimaryColorInverse = Colors.red;
          bgImage = 'assets/images/watercolor-g.png';
          break;
        case 7:
          _savedBox.put('themeMode', 7);
          appPrimaryColor = Colors.blue;
          appPrimaryColor200 = Colors.blue[300]!;
          appPrimaryColorInverse = Colors.red;
          bgImage = 'assets/images/watercolor-bw.png';
          break;
        case 8:
          _savedBox.put('themeMode', 8);
          appPrimaryColor = Colors.grey;
          appPrimaryColor200 = Colors.grey;
          appPrimaryColorInverse = Colors.grey;
          bgImage = 'assets/images/watercolor-grey.png';
          break;
        default:
          appPrimaryColor = Colors.deepPurple[200]!;
          appPrimaryColor200 = Colors.deepPurple[100]!;
          appPrimaryColorInverse = Colors.deepPurple[200]!;
          bgImage = 'assets/images/watercolor.png';
      }
      notifyListeners();
    }

}