

import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/category.dart';


class StoreData extends ChangeNotifier {
List<User> userList=[];
List<Store>storeList=[];
List<Product>productList=[];
List<Categorys> categoryList=[];
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

initCategoryList(categoryList){
  this.categoryList = categoryList;
}
initStoreList(storeList){
  this.storeList = storeList;
}

initProductList(productList){
  this.productList = productList;
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
 

addCategory(category){
  categoryList.add(category);
  notifyListeners();
}


updateCategory(Categorys category){
  
     int u =categoryList.indexWhere((element) => element.id==category.id);
  if(u!=-1){
    categoryList.removeAt(u);
    categoryList.insert(u, category);
    notifyListeners();
  }
  }


 deleteCategory(Categorys category){
  categoryList.remove(category);
  notifyListeners();
} 


addProduct(product){
  productList.add(product);
  notifyListeners();
}


updateProduct(Product product){
  
     int u =productList.indexWhere((element) => element.id==product.id);
  if(u!=-1){
    productList.removeAt(u);
    productList.insert(u, product);
    notifyListeners();
  }
  }


 deleteProduct(Product product){
  productList.remove(product);
  notifyListeners();
} 
 


}