import 'package:flutter/foundation.dart';

class Specials extends ChangeNotifier {

bool productselected = false;
bool scroll = false;
bool istextempty = true;


changeIsEmpty(v){
  istextempty=v;
  notifyListeners();
}

changeProdutcSelected(v){
  productselected=v;
  notifyListeners();
}

changescroll(v){
  scroll= v;
  notifyListeners();
}
}