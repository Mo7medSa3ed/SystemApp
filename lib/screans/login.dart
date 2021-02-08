import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/screans/signup.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/widget.dart';

class LoginScrean extends StatelessWidget {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;

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
                children: [
                  Container(
                      padding: EdgeInsets.all(16.0),
                      width: double.infinity,
                      child: Card(
                        elevation: 12,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 18, horizontal: 35),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(40),
                  ),
                  buildTextFormField(
                     onsaved: (v)=>email=v,
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
                  buildRaisedButton(text: 'تسجيل الدخول',color: Kprimary,pressed: ()async=>await login(context)),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟ '),
                      InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => SignupScrean())),
                          child: Text(
                            'انشاء الآن',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )),
                    ],
                  )
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

  login(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      showDialogWidget(context);
      print(password);
      print(email);
      final res = await API.logIn(username: email, password: password);
      print(res.body);
      if (res.statusCode == 200) {
        saveUser(res.body,context);
        Navigator.pop(context);
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScrean()),(Route<dynamic> route) => false);
      } else {
        Navigator.pop(context);
        showSnackbarWidget(
            msg: 'برجاء ادخال البيانات صحيحة و التاكد من الاتصال بالانترنت !!',
            scaffoldKey: scaffoldKey);
      }
    }
  }
}
