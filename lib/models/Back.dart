import 'package:flutter_app/models/Permission.dart';

class Back {
  num id;
  String storename;
  String username;
  num bill_id;
  List<BackProduct> products;
  String created_at;

  Back(
      {this.id,
      this.created_at,
      this.bill_id,
      this.products,
      this.storename,
      this.username});

  factory Back.fromJson(Map<String, dynamic> json) => Back(
      id: json['id'],
      storename: json['storename'],
      username: json['username'],
      bill_id: json['bill_id'],
      products:  List<BackProduct>.from(json['products'].map( (e) => BackProduct.fromJson(e))),
      created_at: json['created_at']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'storename': storename,
        'username': username,
        'bill_id': bill_id,
        'products': products,
      };

  Map<String, dynamic> toJson() => {
        'storename': storename,
        'username': username,
        'bill_id': bill_id,
        'products': products,
      };
}

class BackProduct {
  num id;
  ProductBackup product;
  num amount;
  String created_at;

  BackProduct({this.amount, this.created_at, this.id, this.product});

  factory BackProduct.fromJson(Map<String, dynamic> json) => BackProduct(
      id: json['id'],
      product:ProductBackup.fromJson( json['product']),
      amount: json['amount'],
      created_at: json['created_at']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'amount': amount,
        'product': product,
      };

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'product': product,
      };
}
