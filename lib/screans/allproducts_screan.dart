import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addproduct.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/tables/producttable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllProductScrean extends StatelessWidget {
  StoreData storeData;
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text('جميع المنتجات'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                  ),
                  onPressed: () =>  ProductDialog(context: context).addproduct()),
              SizedBox(
                width: 15,
              ),
            ],
          ),
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
    );
  }
 
}
