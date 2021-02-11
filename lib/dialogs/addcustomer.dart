import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/Customer.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import '../size_config.dart';
import '../widget.dart';

class CustomerDialog {
  BuildContext context;
  CustomerDialog({this.context, this.type});
  String name, phone, address, type;
  bool expanded = false;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();

  addcustomer({Customer customer}) {
    SizeConfig().init(context);
    storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: customer != null ? "تعديل $type" : "اضف $type",
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
                      value: customer != null ? customer.name : null,
                      onsaved: (v) => name = v,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'اسم $type',
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: customer != null ? customer.address : null,
                      onsaved: (v) => address = v,
                      secure: false,
                      hint: 'اكتب العنوان',
                      label: 'عنوان $type',
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: customer != null ? customer.phone : null,
                      onsaved: (v) => phone = v,
                      secure: false,
                      hint: 'التليفون',
                      label: 'تليفون $type',
                      keyboardType: TextInputType.phone),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Kprimary,
            height: getProportionateScreenHeight(50),
            onPressed: () async {
              customer != null ? await update(customer) : await add();
              customer = null;
            },
            child: Center(
              child: Text(
                customer != null ? "تعديل $type" : "اضف $type",
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]).show();
  }

  add() async {
    formKey.currentState.save();
    if (name == null || phone == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Customer customer =
          Customer(address: address, phone: phone, type: type, name: name);
      final res = await API.addcustomer(customer);
      if (res != null) {
        storeData.addcustomer(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة $type بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  update(Customer customer) async {
    formKey.currentState.save();
    if (name == null) {
      name = customer.name;
    }
    if (phone == null) {
      phone = customer.phone;
    }
    if (address == null) {
      address = customer.address;
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Customer c =
          Customer(id: customer.id, name: name, address: address, phone: phone ,type: type);
      final res = await API.updatecustomer(c);
      if (res != null) {
        storeData.updatecustomer(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم تعديل $type بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  deletecustomer(Customer customer) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
        onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deletecustomer(customer.id);
          if (res.statusCode == 200) {
            storeData.deletecustomer(customer);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف $type بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }
}
