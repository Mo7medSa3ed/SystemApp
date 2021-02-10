import 'package:flutter_app/models/CustomerBackeup.dart';

class Permission {
  num id;
  String type;
  UserBackup user;
  String created_at;
  CustomerBackeup customer;
  num sum;
  num discount;
  num paidMoney;
  String customerName;
  num customerId;
  String paidType;
  List<ProductBackup> items;
  List<BacksId> backs;

  Permission(
      {this.backs,
      this.created_at,
      this.customer,
      this.id,
      this.items,
      this.discount,
      this.paidMoney,
      this.paidType,
      this.sum,
      this.type,
      this.user});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json['id'],
        type: json['type'],
        user: UserBackup.fromJson(json['user']),
        created_at: json['created_at'],
        sum: json['sum'],
        discount: json['discount'],
        paidMoney: json['paidMoney'],
        customer:CustomerBackeup.fromJson( json['customer']),
        paidType: json['paidType'],
        items: List<ProductBackup>.from(
            json['items'].map((e) => ProductBackup.fromJson(e))),
        backs:
            List<BacksId>.from(json['backs'].map((e) => BacksId.fromJson(e))),
      );
  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'type': type,
        'user': user.toJsonForUpdate(),
        'paidMoney': paidMoney,
        'discount': discount,
        'customer': customer.toJsonForUpdate(),
        'paidType': paidType,
        'items': items.map((e) => e.toJsonForUpdate()).toList(),
      };

  Map<String, dynamic> toJson() => {
        'type': type,
        'user': user.toJson(),
        'paidMoney': paidMoney,
         'discount': discount,
        'customer': customer.toJson(),
        'paidType': paidType,
        'items': items.map((e) => e.toJsonForUpdate()).toList(),
      };
}

class ProductBackup {
  num id;
  String productName;
  num productId;
  num sell_price;
  num buy_price;
  num categoryId;
  num storeid;
  num amount_before;
  num amount_after;
  num amount;
  String created_at;

  ProductBackup(
      {this.amount,
      this.amount_after,
      this.amount_before,
      this.buy_price,
      this.categoryId,
      this.created_at,
      this.storeid,
      this.id,
      this.productId,
      this.productName,
      this.sell_price});

  factory ProductBackup.fromJson(Map<String, dynamic> json) => ProductBackup(
        id: json['id'],
        productName: json['productName'],
        productId: json['productId'],
        sell_price: json['sell_price'],
        buy_price: json['buy_price'],
        categoryId: json['categoryId'],
        storeid: json['storeid'],
        amount_before: json['amount_before'],
        amount_after: json['amount_after'],
        amount: json['amount'],
        created_at: json['created_at'],
      );

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'productName': productName,
        'productId': productId,
        'sell_price': sell_price,
        'buy_price': buy_price,
        'storeid': storeid,
        'categoryId': categoryId,
        'amount_before': amount_before,
        'amount_after': amount_after,
        'amount': amount,
      };

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productId': productId,
        'sell_price': sell_price,
        'buy_price': buy_price,
        'storeid': storeid,
        'categoryId': categoryId,
        'amount_before': amount_before,
        'amount_after': amount_after,
        'amount': amount,
      };
}

class UserBackup {
  num id;
  String username;
  String password;
  String role;
  String created_at;

  UserBackup(
      {this.created_at, this.id, this.password, this.role, this.username});

  factory UserBackup.fromJson(Map<String, dynamic> json) => UserBackup(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      created_at: json['created_at']);

  Map<String, dynamic> toJsonForUpdate() =>
      {'id': id, 'password': password, 'username': username, 'role': role};

  Map<String, dynamic> toJson() =>
      {'password': password, 'username': username, 'role': role};
}

class BacksId {
  num id;
  num backsId;

  BacksId({this.id, this.backsId});

  factory BacksId.fromJson(Map<String, dynamic> json) =>
      BacksId(id: json['id'], backsId: json['backsId']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'backsId': backsId,
      };

  Map<String, dynamic> toJson() => {
        'backsId': backsId,
      };
}
