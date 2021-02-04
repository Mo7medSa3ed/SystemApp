import 'package:flutter/foundation.dart';

class Specials extends ChangeNotifier {

bool istextempty = true;

changeIsEmpty(v){
  istextempty=v;
  notifyListeners();
}

}