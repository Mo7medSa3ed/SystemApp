import 'dart:convert';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;

class API {
  static String _BASE_URL = 'https://morning-crag-76907.herokuapp.com';

  // functions For user
  static Future<http.Response> signUp(User user) async {
    final response = await http.post('$_BASE_URL/users/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(user.toJson()));
    return response;
  }

  static Future<http.Response> updateUser(List<User> user) async {
    final response = await http.put('$_BASE_URL/users/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: json.encode(user.map((e) => e.toJsonForUpdate()).toList()));
    return response;
  }

  static Future<http.Response> logIn({String username, String password}) async {
    final response = await http.get(
      '$_BASE_URL/users/login?username=$username&password=$password',
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8'
      },
    );

    return response;
  }

  static Future<http.Response> deleteUser(List<num> id) async {
    final response = await http.post('$_BASE_URL/users/one',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(id));
    return response;
  }

  static Future<List<User>> getAllUsers() async {
    final response = await http.get('$_BASE_URL/users/all');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed.map<User>((user) => User.fromJson(user)).toList();
  }

  static Future<User> getOneUser(num id) async {
    final response = await http.get('$_BASE_URL/users/one/$id');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return User.fromJson(parsed);
  }

  // functions For store
  static Future<Store> addStore(Store store) async {
    final response = await http.post('$_BASE_URL/stores/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(store.toJson()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Store.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<http.Response> deleteStore(num id) async {
    final response = await http.delete('$_BASE_URL/stores/one/$id');
    return response;
  }

  static Future<Store> updateStore(Store store) async {
    final response = await http.put('$_BASE_URL/stores/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(store.toJsonForUpdate()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Store.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<List<Store>> getAllstores() async {
    final response = await http.get('$_BASE_URL/stores/all');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed.map<Store>((store) => Store.fromJson(store)).toList();
  }

  static Future<Store> getOnestore(num id) async {
    final response = await http.get('$_BASE_URL/stores/one/$id');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return Store.fromJson(parsed);
  }

    //function for products

  static Future<Product> addProduct(Product product) async {
    final response = await http.post('$_BASE_URL/products/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(product.toJson()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Product.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<http.Response> deleteProduct(num id) async {
    final response = await http.delete('$_BASE_URL/products/one/$id');
    return response;
  }

  static Future<Product> updateProduct(Product product) async {
    final response = await http.put('$_BASE_URL/products/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(product.toJsonForUpdate()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Product.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<List<Product>> getAllProducts() async {
    final response = await http.get('$_BASE_URL/products/all');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed.map<Product>((product) => Product.fromJson(product)).toList();
  }

  static Future<Product> getOneProduct(num id) async {
    final response = await http.get('$_BASE_URL/products/one/$id');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return Product.fromJson(parsed);
  }



  //function for categories


  static Future<Categorys> addCategory(Categorys category) async {
    final response = await http.post('$_BASE_URL/categories/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(category.toJson()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Categorys.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<http.Response> deleteCategory(num id) async {
    final response = await http.delete('$_BASE_URL/categories/one/$id');
    return response;
  }

  static Future<Categorys> updateCategory(Categorys category) async {
    final response = await http.put('$_BASE_URL/categories/all',
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: json.encode(category.toJsonForUpdate()));
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final parsed = json.decode(body);
      return Categorys.fromJson(parsed);
    } else {
      return null;
    }
  }

  static Future<List<Categorys>> getAllCategories() async {
    final response = await http.get('$_BASE_URL/categories/all');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return parsed.map<Categorys>((category) => Categorys.fromJson(category)).toList();
  }

  static Future<Categorys> getOneCategory(num id) async {
    final response = await http.get('$_BASE_URL/categories/one/$id');
    final body = utf8.decode(response.bodyBytes);
    final parsed = json.decode(body).cast<Map<String, dynamic>>();
    return Categorys.fromJson(parsed);
  }


}
