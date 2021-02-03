import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextFormField buildTextFormField(
    {label, hint, keyboardType, secure, password, email,onsaved ,value}) {
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
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        hintText: hint,
        suffixIcon: Icon(secure ? Icons.lock : Icons.email)),
  );
}

Widget buildRaisedButton({pressed, text}) {
  return Container(
      width: double.infinity,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Kprimary,
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
  storeData.initLoginUser(user);
}

 
 