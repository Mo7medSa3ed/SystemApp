import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/tables/permisiontabledetails.dart';
import 'package:provider/provider.dart';

class PermisionDetailsScrean extends StatelessWidget {
  StoreData storeData;
  Permission p;
  PermisionDetailsScrean(this.p);
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('تفاصيل الإذن'),
          ),
          drawer: MainDrawer(),
          body: body(context),
        ));
  }

  Widget body(context) {
    return ListView(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  card(context, true, 'اسم المخزن :\t','اتحذفت'
                    ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  card(context, true, 'نوع الإذن :\t',
                      p.type == 'add' ? 'اضافة' : 'صرف'),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  card(context, false, 'اسم العامل :\t', p.user.username),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  card(context, false, 'التاريخ :\t',
                      p.created_at.substring(0, 10)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16),
          child: Text(
            'المنتجات :  ',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          ),
        ),
        PermisionTableDetails(p.items, p.type),
      ],
    );
  }

  Widget card(context, val, title, text) {
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 60,
        decoration: BoxDecoration(
            border: Border(
                left: val
                    ? BorderSide.none
                    : BorderSide(width: 6, color: Kprimary),
                right: !val
                    ? BorderSide.none
                    : BorderSide(width: 5, color: Kprimary))),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            )
          ],
        ),
      ),
    );
  }
}
