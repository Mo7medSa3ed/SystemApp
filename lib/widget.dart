import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextFormField buildTextFormField(
    {label, hint, keyboardType, secure,icon,onsaved ,value}) {
  return TextFormField(
    initialValue:value ,
    onSaved: onsaved,
    validator: (e) => e.toString().isEmpty
        ? secure
            ? 'برجاء ادخال كلمة السر !!'
            : ' برجاء ادخال الاسم !!'
        : null,
    obscureText: secure,
    keyboardType: keyboardType,
    maxLengthEnforced:keyboardType==TextInputType.number?true:false,
    maxLength:keyboardType==TextInputType.number?7:keyboardType==TextInputType.phone?11:null,
    inputFormatters: keyboardType==TextInputType.number?[FilteringTextInputFormatter.digitsOnly]:null,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        hintText: hint,
        suffixIcon: Icon(icon)),
  );
}

Widget buildRaisedButton({pressed, text ,color}) {
  return Container(
      width: double.infinity,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: color,
          onPressed: pressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              text,
              style: TextStyle(
                  color: white, fontSize: 18, fontWeight: FontWeight.w400),
            ),
          )));
}

showDialogWidget(context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()));
}

showSnackbarWidget({msg, scaffoldKey}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    elevation: 2,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.error),
        Text(
          msg,
          style: TextStyle(color: white, fontSize: 14),
          textDirection: TextDirection.rtl,
        ),
      ],
    ),
    backgroundColor: Kprimary,
  ));
}

saveUser(user,context) async {
  final prfs = await SharedPreferences.getInstance();
  StoreData storeData = Provider.of<StoreData>(context,listen: false);
  prfs.setString('user', user);
  final parsed = json.decode(user);
    User u = User.fromJson(parsed);
  storeData.initLoginUser(u);
}




 