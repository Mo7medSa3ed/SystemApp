import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/widget.dart';
import 'package:provider/provider.dart';

class SignupScrean extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String username, password, role, storename;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    new SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Card(
                      elevation: 12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 35),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                'انشاء حساب',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(40),
                              ),
                              buildTextFormField(
                                onsaved: (v)=>username=v,
                                  icon: Icons.email,
                                  secure: false,
                                  hint: 'اكتب اسمك',
                                  label: 'الاسم',
                                  keyboardType: TextInputType.emailAddress),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              buildTextFormField(
                                onsaved: (v)=>password=v,
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
                                  headertext: 'اختر الوظيفة',
                                  list: roleList,
                                  value: true),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              buildDropDown(
                                  expanded: expanded,
                                  headertext: 'اختر المخزن التابع له',
                                  list: Provider.of<StoreData>(context,
                                          listen: false)
                                      .storeList.map((e) => e.storename).toList(),
                                  value: false),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              buildRaisedButton(
                                color: Kprimary,
                                  text: 'انشاء حساب',
                                  pressed: () async => await signup(context)),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signup(context) async {
    if (storename != null && role != null) {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();
        showDialogWidget(context);
        User user = User(
            username: username,
            password: password,
            role: role,
            storeid: getStoreid(context: context, storename: storename));
        final res = await API.signUp(user);
        if (res.statusCode == 200) {
          final y =utf8.decode(res.bodyBytes);
          saveUser(y,context);
          Navigator.pop(context);
          Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScrean()),(Route<dynamic> route) => false  );
        } else {
          Navigator.pop(context);
          showSnackbarWidget(
              msg:
                  'برجاء ادخال البيانات صحيحة و التاكد من الاتصال بالانترنت !!',
              scaffoldKey: scaffoldKey);
          return;
        }
      }
    } else if (storename != null || role != null) {
      showSnackbarWidget(
          msg: 'برجاء استكمال البيانات المطلوبة !!', scaffoldKey: scaffoldKey);
      return;
    }
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
}
