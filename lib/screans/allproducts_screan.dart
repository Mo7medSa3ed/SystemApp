import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addproduct.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/tables/producttable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllProductScrean extends StatelessWidget {
  StoreData storeData;
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () =>  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScrean()),
                    (Route<dynamic> route) => false),
              child: Scaffold(
            appBar: AppBar(
              title: Text('جميع المنتجات'),
            ),
            floatingActionButton: buildSpeedDial(context),
            drawer: MainDrawer(),
            body: FutureBuilder<List<Product>>(
              future: API.getAllProducts(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initProductList(snap.data);

                  return ProductTable();
                
                } else {
                  return SpinKitCircle(
                    color: Kprimary,
                  );
                }
              },
            )),
      ),
    );
  }
 
  Widget buildSpeedDial(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(right: 35, bottom: 5),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          overlayColor: Colors.transparent,
          overlayOpacity: 0,
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.delete_forever, color: Colors.white),
              backgroundColor: Colors.deepOrange,
              onTap: () {
                final List<num> list = storeData.productList
                    .where((element) => element.selected)
                    .toList()
                    .map((e) => e.id).toList(); 
                   
                list.length>0?ProductDialog(context: context).deleteProducts(list):Dialogs(context).warningDilalog2(msg:"!! برجاء اختيار منتح ع الأقل");
              },
              label: 'حذف  ',
              labelStyle: TextStyle(fontWeight: FontWeight.w500, color: white),
              labelBackgroundColor: Colors.deepOrangeAccent,
            ),
            SpeedDialChild(
              child: Icon(Icons.move_to_inbox, color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () {
                List<Product> list = storeData.productList
                    .where((element) => element.selected)
                    .toList();
                list.length>0?ProductDialog(context: context).moveToStoreDialog(list):Dialogs(context).warningDilalog2(msg:"!! برجاء اختيار منتح ع الأفل");
              },
              label: 'نقل لمخزن آخر',
              labelStyle: TextStyle(fontWeight: FontWeight.w500, color: white),
              labelBackgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }



}
