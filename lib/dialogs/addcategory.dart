import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import '../size_config.dart';
import '../widget.dart';

class CategoryDialog {
  BuildContext context;
  CategoryDialog({this.context});
  String name;
  bool expanded = false;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();

  addcategory({Categorys category}) {
    SizeConfig().init(context);
          storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: category != null ? "تعديل فئة" : "اضف فئة",
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width -40,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildTextFormField(
                      value: category != null ? category.name : null,
                      onsaved: (v) => name = v,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'اسم الفئة',
                      keyboardType: TextInputType.text),
               
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Kprimary,
            height: getProportionateScreenHeight(50),
            onPressed:()async {
            category!=null?await update(category):await add();
            category=null;
            },
            child: Center(
              child: Text(
                category != null ? "تعديل فئة" : "اضف فئة",
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]).show();
  }


  add() async {
    
    formKey.currentState.save();
    if (name == null ) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Categorys category = Categorys(
        productslength: 0.0,
          name: name);
      final res = await API.addCategory(category);
      if (res!=null) {
        storeData.addCategory(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة فئة بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  update(Categorys category) async {
    formKey.currentState.save();
    if (name == null) {
      name =category.name;
    }
     else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
       Categorys c = Categorys(
         id: category.id,
          name: name);
      final res = await API.updateCategory(c);
      if (res!=null) {
        storeData.updateCategory(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم تعديل الفئة بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  deletecategory(Categorys category) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
         onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deleteCategory(category.id);
          if (res.statusCode == 200) {
            storeData.deleteCategory(category);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف الفئة بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }
  
  




  
}
