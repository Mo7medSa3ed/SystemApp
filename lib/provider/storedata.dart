
import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/models/user.dart';

class StoreData extends ChangeNotifier {
List<User> userList=[];
List<Store>storeList=[];
List<Product>productList=[];
bool isCheckable=false;
User loginUser;

initLoginUser(User user){
  loginUser =user;
} 


changeCheckable(v){
  isCheckable=v;
  notifyListeners();
}

initUserList(userList){
  this.userList = userList;
}

initStoreList(storeList){
  this.storeList = storeList;
}

initProductList(productList){
  this.productList = productList;
}

List<String>getStoreNameList(){
  List<String> list =[];
  storeList.forEach((element) =>list.add(element.storename));
  return list;
}

addUser(User user){
  userList.add(user);
  notifyListeners();
}

updateUser(List<User> users){
  users.forEach((user) {
     int u =userList.indexWhere((element) => element.id==user.id);
  if(u!=-1){
    userList.removeAt(u);
    userList.insert(u, user);
    notifyListeners();
  }
  });
 
}
deleteUser(List<User> users){
  users.forEach((element) =>userList.remove(element));  
  notifyListeners();
}


deleteManyOfUsers(List<num> users){
  users.forEach((element) {
    userList.removeWhere( (e)=> e.id == element);
  });  
  notifyListeners();
}


addStore(store){
  storeList.add(store);
  notifyListeners();
}


updateStore(Store store){
  
     int u =storeList.indexWhere((element) => element.id==store.id);
  if(u!=-1){
    storeList.removeAt(u);
    storeList.insert(u, store);
    notifyListeners();
  }
  }


 deleteStore(Store store){
  storeList.remove(store);
  notifyListeners();
} 
 




}