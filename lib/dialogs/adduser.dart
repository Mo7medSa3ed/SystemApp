import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';
import '../size_config.dart';
import '../widget.dart';

class Usersdialog {
  BuildContext context;
  Usersdialog({this.context});
  String username, password, role, storename;
  bool expanded = false;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();

  addUser({User user}) {
     storeData = Provider.of<StoreData>(context, listen: false);
    SizeConfig().init(context);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: user != null ? "تعديل عامل" : "اضف عامل",
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildTextFormField(
                      value: user != null ? user.username : null,
                      onsaved: (v) => username = v,
                      icon: Icons.email,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'الاسم',
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: user != null ? user.password : null,
                      onsaved: (v) => password = v,
                      icon: Icons.lock,
                      secure: true,
                      hint: 'اكتب كلمة السر',
                      label: 'كلمة السر',
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildDropDown(
                      expanded: expanded,
                      headertext: user != null ? user.role : 'اختر الوظيفة',
                      list: roleList,
                      value: true),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildDropDown(
                      expanded: expanded,
                      headertext: user != null
                          ? getStoreName(
                              context: context, storeid: user.storeid)
                          : 'اختر المخزن التابع له',
                      list: storeData.storeList.map((e) => e.storename).toList(),
                      value: false),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
                        height: getProportionateScreenHeight(40),

            color: Kprimary,
            onPressed: () async {
              user != null ? await update(user) : await add();
              storename = null;
              password = null;
              storename = null;
              role = null;
            },
            child: Center(
              child: Text(
                user != null ? "تعديل عامل" : "اضف عامل",
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          )
        ]).show();
  }

  Widget buildDropDown(
      {bool expanded, String headertext, List<String> list, bool value}) {
    return StatefulBuilder(
      builder: (ctx, setstate) => Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: expanded ? Kprimary : grey, width: expanded ? 2 : 1.2),
            borderRadius: BorderRadius.circular(4)),
        child: new ExpansionPanelList(
          elevation: 0,
          expansionCallback: (int index, bool status) {
            setstate(() => expanded = !expanded);
          },
          children: [
            new ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: expanded,
              headerBuilder: (BuildContext context, bool isExpanded) =>
                  new Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: ListTile(
                          trailing: value
                              ? role != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          role = null;
                                          expanded = false;
                                        });
                                      },
                                    )
                                  : null
                              : storename != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          storename = null;
                                          expanded = false;
                                        });
                                      },
                                    )
                                  : null,
                          title: Text(value
                              ? role != null
                                  ? role
                                  : headertext
                              : storename != null
                                  ? storename
                                  : headertext))),
              body: Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => setstate(() {
                            value ? role = e : storename = e;
                            expanded = false;
                          }),
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  add() async {
    formKey.currentState.save();
    if (username == null ||
        password == null ||
        role == null ||
        storename == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      User user = User(
          username: username,
          password: password,
          role: role,
          storeid: getStoreid(context: context, storename: storename));
      final res = await API.signUp(user);
      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes);
        final u = User.fromJson(json.decode(body));
        storeData.addUser(u);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة عامل بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  update(User user) async {
    formKey.currentState.save();

    if (role == null) {
      role = user.role;
    }
    if (storename == null) {
      storename = getStoreName(context: context, storeid: user.storeid);
    }

    if (username == null ||
        password == null ||
        role == null ||
        storename == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      User us = User(
          id: user.id,
          username: username,
          password: password,
          role: role,
          storeid: getStoreid(context: context, storename: storename));
      final res = await API.updateUser([us]);
      if (res.statusCode == 200) {
        us.created_at=DateTime.now().toString();
        storeData.updateUser([us]);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم تعديل العامل بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  deleteUser(User user ) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
         onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);

          final res = await API.deleteUser([user.id]);
          if (res.statusCode == 200) {
            storeData.deleteUser([user]);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف العامل بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }
  
  deleteUsers(List<num> user ) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
         onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deleteUser(user);
          if (res.statusCode == 200) {
            storeData.deleteManyOfUsers(user);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف العامل بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }

  moveToStore(List<User> users)async{
  if(storename==null){
     return Dialogs(context).infoDilalog();
  }else{
    showDialogWidget(context);
    storeData = Provider.of<StoreData>(context, listen: false);
    users.forEach((element) {
        element.storeid=getStoreid(context: context,storename: storename);
    });
    final res = await API.updateUser(users);
    if (res.statusCode == 200) {
        storeData.updateUser(users);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم نقل العمال بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
  }
}

  moveToStoreDialog(List<User> users) {
    storeData = Provider.of<StoreData>(context, listen: false);
    SizeConfig().init(context);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title:'نقل لمخزن آخر',
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width *0.60,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  
                  buildDropDown(
                      expanded: expanded,
                      headertext: 'اختر المخزن المراد النقل اليه',
                      list:storeData.storeList.map((e) => e.storename).toList(),
                      value: false),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
                        height: getProportionateScreenHeight(40),

            color: Kprimary,
            onPressed: () async {
              await moveToStore(users);
              storename=null;
            },
            child: Center(
              child: Text('نقل',
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          )
        ]).show();
  }





  
}
