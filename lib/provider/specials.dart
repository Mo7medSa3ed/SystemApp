import 'package:flutter/foundation.dart';

class Specials extends ChangeNotifier {

bool istextempty = true;
bool productselected = false;
bool scroll = false;


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