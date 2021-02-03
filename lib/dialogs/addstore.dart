import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';
import '../size_config.dart';
import '../widget.dart';

class Storesdialog {
  BuildContext context;
  Storesdialog({this.context});
  String storename, address, manger;
  bool expanded = false;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();

  addstore({Store store}) {
    SizeConfig().init(context);
          storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: store != null ? "تعديل مخزن" : "اضف مخزن",
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
                      value: store != null ? store.storename : null,
                      onsaved: (v) => storename = v,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'اسم المخزن',
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: store != null ? store.address: null,
                      onsaved: (v) => address = v,
                      secure: false,
                      hint: 'اكتب العنوان',
                      label: 'العنوان',
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildDropDown(
                      expanded: expanded,
                      headertext: store != null ? getUsername(context: context,userid: store.manager) : 'اختر المدير',
                      list: storeData.userList.map((e) => e.username).toList(),
                      value: true),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
               
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Kprimary,
            height: getProportionateScreenHeight(40),
            onPressed:()async {
            store!=null?await update(store):await add();
            storename=null;
            address=null;
            manger=null;
            },
            child: Center(
              child: Text(
                store != null ? "تعديل مخزن" : "اضف مخزن",
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
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
                              ? manger != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          manger = null;
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
                              ? manger != null
                                  ? manger
                                  : headertext
                              : storename != null
                                  ? storename
                                  : headertext))),
              body: Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => setstate(() {
                            value ? manger = e : storename = e;
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
    if (storename == null ||
        address == null ||
        manger == null 
        ) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Store store = Store(
          storename: storename,
          address: address,
          manager: getUserid(context: context, username: manger));
      final res = await API.addStore(store);
      if (res!=null) {
        storeData.addStore(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة مخزن بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  update(Store store) async {
    formKey.currentState.save();
    if (manger == null) {
      manger =  getUsername(context: context, userid: store.manager);
    }
    if (storename == null ||
        address == null ||
        manger == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Store us = Store(
          id: store.id,
          storename: storename,
          address: address,
          manager:getUserid(context: context, username: manger));
      final res = await API.updateStore(us);
      if (res!=null) {
        storeData.updateStore(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم تعديل المخزن بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  deletestore(Store store ) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
         onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deleteStore(store.id);
          if (res.statusCode == 200) {
            storeData.deleteStore(store);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف المخزن بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }
  
  




  
}
