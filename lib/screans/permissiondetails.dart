import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/allpermissions_screan.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/tables/permisiontabledetails.dart';
import 'package:flutter_app/widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PermisionDetailsScrean extends StatelessWidget {
  StoreData storeData;
  num i ;
  PermisionDetailsScrean(this.i);

  String money;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => AllPermissionsScrean())),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('تفاصيل الإذن'),
            ),
            body: Consumer<StoreData>(builder: (c, v, s) => body(context,v.permissionList[i])),
          ),
        ));
  }

  Widget body(context,Permission v) {
    return ListView(
      children: [
        buildheader(v),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'جميع المنتجات :  ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
                ),
              ),
              Expanded(
                  child: buildRaisedButton(
                      text: "تحصيل",
                      color:v.paidType=='نقدى'?Kprimary.withOpacity(0.3) : Kprimary,
                      pressed: () =>v.paidType=='نقدى'?null:paidmoney(context, v)))
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        PermisionTableDetails(v.items, v.type),
      ],
    );
  }

  Widget buildheader(p) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Card(
        elevation: 2,
        child: Column(children: [
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.person),
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            title:
                Text('العامل', style: TextStyle(fontWeight: FontWeight.w700)),
            children: [
              buildRow('اسم العامل :', p.user.username),
              buildRow('الوظيفة :', p.user.role),
              buildRow('تاريخ الانضمام :', p.user.created_at.substring(0, 10)),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.person),
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            title:
                Text('العميل', style: TextStyle(fontWeight: FontWeight.w700)),
            children: [
              buildRow('اسم العميل :', p.customer.name),
              buildRow('نوع الدفع :', p.paidType),
              buildRow('المبلغ المدفوع :', p.paidMoney.toString()),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.security),
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            title:
                Text('تفاصيل', style: TextStyle(fontWeight: FontWeight.w700)),
            children: [
              buildRow('نوع الإذن :', p.type == 'add' ? 'اضافة' : 'صرف'),
              buildRow('المبلغ الكلى :', p.sum.toString()),
              buildRow('تاريخ الصرف :', p.created_at.substring(0, 10)),
            ],
          )
        ]),
      ),
    );
  }

  Widget buildRow(text, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(text, style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  paidmoney(context, Permission p) {
    SizeConfig().init(context);
    storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: 'تحصيل الفاتورة',
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  Text(
                    'الاجمالى  ${p.sum}\nالمبلغ المدفوع  ${p.paidMoney}\nالمبلغ المتبقى  ${p.sum - p.paidMoney}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: null,
                      icon: Icons.monetization_on,
                      onsaved: (v) => money = v,
                      secure: false,
                      hint: 'المبلغ',
                      label: 'ادخل المبلغ',
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Kprimary,
            height: getProportionateScreenHeight(40),
            onPressed: () async => await paid(context,p),
            child: Center(
              child: Text(
                'دفع',
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]).show();
  }

  paid(context,p) async {
    formKey.currentState.save();
    if (money.toString() == '') {
      return Dialogs(context)
          .warningDilalog2(msg: 'برجاء ادخال المبلغ المطلوب !!');
    } else if (double.parse(money) == 0) {
      return Dialogs(context)
          .warningDilalog2(msg: 'برجاء ادخال المبلغ المطلوب !!');
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Permission per = Permission(id: p.id, paidMoney: double.parse(money));
      final res = await API.updatepermission(per);
      if (res != null) {
        storeData.updatePermission(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم الدفع بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }
}
