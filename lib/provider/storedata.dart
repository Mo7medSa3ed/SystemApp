import 'package:flutter/foundation.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/models/Customer.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/category.dart';

class StoreData extends ChangeNotifier {
  List<User> userList = [];
  List<Store> storeList = [];
  List<Product> productList = [];
  List<Product> productTableList = [];
  List<Categorys> categoryList = [];
  List<Customer> customerList = [];
  List<Permission> permissionList = [];
  List<Back> backs=[];
  double sum = 0.0;
  bool paid = false;
  changepaid(v) {
    paid = v;
    notifyListeners();
  }

  bool isCheckable = false;
  User loginUser;

  initLoginUser(User user) {
    loginUser = user;
  }

  changeCheckable(v) {
    isCheckable = v;
    notifyListeners();
  }

  initUserList(userList) {
    this.userList = userList;
  }

  initbackList(backs) {
    this.backs = backs;
  }

  initCategoryList(categoryList) {
    this.categoryList = categoryList;
  }

  initPermissionList(permissionList) {
    this.permissionList = permissionList;
  }

  initcustomerList(customerList) {
    this.customerList = customerList;
  }

  initStoreList(storeList) {
    this.storeList = storeList;
  }

  initProductList(productList) {
    this.productList = productList;
  }

  addUser(User user) {
    userList.add(user);
    notifyListeners();
  }

  updateUser(List<User> users) {
    users.forEach((user) {
      int u = userList.indexWhere((element) => element.id == user.id);
      if (u != -1) {
        userList.removeAt(u);
        userList.insert(u, user);
        notifyListeners();
      }
    });
  }

  deleteUser(List<User> users) {
    users.forEach((element) => userList.remove(element));
    notifyListeners();
  }

  deleteManyOfUsers(List<num> users) {
    users.forEach((element) {
      userList.removeWhere((e) => e.id == element);
    });
    notifyListeners();
  }

  addStore(store) {
    storeList.add(store);
    notifyListeners();
  }

  updateStore(Store store) {
    int u = storeList.indexWhere((element) => element.id == store.id);
    if (u != -1) {
      storeList.removeAt(u);
      storeList.insert(u, store);
      notifyListeners();
    }
  }

  deleteStore(Store store) {
    storeList.remove(store);
    notifyListeners();
  }

  addCategory(category) {
    categoryList.add(category);
    notifyListeners();
  }

  updateCategory(Categorys category) {
    int u = categoryList.indexWhere((element) => element.id == category.id);
    if (u != -1) {
      categoryList.removeAt(u);
      categoryList.insert(u, category);
      notifyListeners();
    }
  }

  deleteCategory(Categorys category) {
    categoryList.remove(category);
    notifyListeners();
  }

  addProduct(product) {
    productList.add(product);
    notifyListeners();
  }

  updateProduct(List<Product> p) {
    p.forEach((product) {
      int u = productList.indexWhere((element) => element.id == product.id);
      if (u != -1) {
        productList.removeAt(u);
        productList.insert(u, product);
      }
    });

    notifyListeners();
  }

  deleteProduct(List<Product> products) {
    products.forEach((element) => productList.remove(element));
    notifyListeners();
  }

  deleteManyOfProducts(List<num> products) {
    products.forEach((element) {
      productList.removeWhere((e) => e.id == element);
    });
    notifyListeners();
  }

  addproductTable(amount, Product product, context) {
    if (productTableList.length > 0) {
      final p = productTableList.firstWhere((e) => e.id == product.id,
          orElse: () => null);
      if (p != null) {
        if ((p.amount + amount) > product.amount) {
          Dialogs(context)
              .warningDilalog2(msg: 'اقصى كمية يمكن صرفها ${product.amount}');
          return;
        } else {
          num a = (p.amount * product.sell_price);
          sum = sum - a;
          p.amount = (p.amount + amount);
          updateproductTable(p);
        }
      } else {
        productTableList.add(product);
        sum += (amount * product.sell_price);
      }
    } else {
      product.amount = amount;
      productTableList.add(product);
      sum += (amount * product.sell_price);
    }
    print(sum);
    notifyListeners();
  }

  updateproductsTable(List<Product> p) {
    p.forEach((product) {
      int u =
          productTableList.indexWhere((element) => element.id == product.id);
      if (u != -1) {
        productTableList.removeAt(u);
        productTableList.insert(u, product);
      }
    });

    notifyListeners();
  }

  updateproductTable(Product p) {
    int u = productTableList.indexWhere((element) => element.id == p.id);
    if (u != -1) {
      productTableList.removeAt(u);
      productTableList.insert(u, p);
      sum += (p.amount * p.sell_price);
    }

    notifyListeners();
  }

  deleteproductTable(Product products) {
    sum -= (products.amount * products.sell_price);
    productTableList.remove(products);
    notifyListeners();
  }

  deleteManyOfproductsTable(List<Product> products) {
    products.forEach((element) {
      productTableList.remove(element);
    });
    notifyListeners();
  }

  addcustomer(customer) {
    customerList.add(customer);
    notifyListeners();
  }

  updatecustomer(Customer customer) {
    int u = customerList.indexWhere((element) => element.id == customer.id);
    if (u != -1) {
      customerList.removeAt(u);
      customerList.insert(u, customer);
      notifyListeners();
    }
  }

  deletecustomer(Customer customer) {
    customerList.remove(customer);
    notifyListeners();
  }

  addPermission(permission) {
    permissionList.add(permission);
    notifyListeners();
  }
}
