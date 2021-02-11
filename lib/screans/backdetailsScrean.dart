import 'package:flutter/material.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/tables/backtabledetails.dart';
import 'package:provider/provider.dart';

class BackdetailsScrean extends StatelessWidget {
  StoreData storeData;
  Back p;
  BackdetailsScrean(this.p);
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('تفاصيل الإذن'),
          ),
          body: body(context),
        ));
  }

  Widget body(context) {
    return ListView(
      children: [
        buildheader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'جميع المنتجات :  ',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          ),
        ),
        BackTableDetails([])
      ],
    );
  }

  Widget buildheader() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Card(
        elevation: 2,
        child: Column(children: [
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.details),
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            title:
                Text('التفاصيل', style: TextStyle(fontWeight: FontWeight.w700)),
            children: [
              buildRow('فاتورة رقم :', p.bill_id.toString()),
              buildRow('رقم الإذن :', p.id.toString()),
              buildRow('المخزن :', p.storename),
              buildRow('اسم العامل :', p.username),
              buildRow('تاريخ الإنشاء :', p.created_at.substring(0,10) )
            ],
          ),
          ExpansionTile(
            initiallyExpanded: true,
            leading: Icon(Icons.person),
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            title:
                Text('العميل', style: TextStyle(fontWeight: FontWeight.w700)),
            children: [
              buildRow('الاسم :', p.customer.name),
              buildRow('نوعه :', p.customer.type),
              buildRow('العنوان :', p.customer.address.isEmpty?"لا يتم تحديده":p.customer.address),
              buildRow('التلفون :', p.customer.phone),
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
}

/**
 * 
 *                  buildRow('فاتورة رقم :', p.bill_id.toString()),
              buildRow('رقم الإذن :', p.id.toString()),
              buildRow('المخزن :', p.storename),
              buildRow('اسم العامل :', p.username),
              buildRow('تاريخ الإنشاء :', p.created_at.substring(0,10) )
 */
