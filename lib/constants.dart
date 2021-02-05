import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

final Kprimary = Colors.deepPurple;
final white = Colors.white;
final black = Colors.black;
final grey = Colors.grey;
final greyw = Colors.grey[200];
final red = Colors.red[900];

final roleList = ['عامل', 'امين مخزن', 'مدير مخزن'];
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

num getStoreid({context, storename}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.storeList.firstWhere(
      (element) => element.storename == storename,
      orElse: () => null);
  if (res != null) {
    return res.id;
  } else {
    return 0;
  }
}

String getStoreName({context, storeid}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.storeList
      .firstWhere((element) => element.id == storeid, orElse: () => null);
  if (res != null) {
    return res.storename;
  } else {
    return "-------";
  }
}

num getUserid({context, username}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.userList.firstWhere(
      (element) => element.username == username,
      orElse: () => null);
  if (res != null) {
    return res.id;
  } else {
    return 0;
  }
}

String getUsername({context, userid}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.userList
      .firstWhere((element) => element.id == userid, orElse: () => null);
  if (res != null) {
    return res.username;
  } else {
    return "-------";
  }
}

Future<User> getUserFromPrfs() async {
  SharedPreferences prfs = await SharedPreferences.getInstance();
  final parsed = json.decode(prfs.getString("user"));
  return User.fromJson(parsed);
}


num getCategoryid({context, name}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.categoryList.firstWhere(
      (element) => element.name == name,
      orElse: () => null);
  if (res != null) {
    return res.id;
  } else {
    return 0;
  }
}

String getCategoryname({context, id}) {
  StoreData storeData = Provider.of<StoreData>(context, listen: false);
  final res = storeData.categoryList.firstWhere(
      (element) => element.id== id,
      orElse: () => null);
  if (res != null) {
    return res.name;
  } else {
    return '-------';
  }
}