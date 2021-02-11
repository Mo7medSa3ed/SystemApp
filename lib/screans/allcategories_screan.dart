import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcategory.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/tables/categorytable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllCategoriesScrean extends StatelessWidget {
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
              title: Text('جميع الفئات'),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 30,
                    ),
                    onPressed: () =>  CategoryDialog(context: context).addcategory()),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            drawer: MainDrawer(),
            body: FutureBuilder<List<Categorys>>(
              future: API.getAllCategories(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initCategoryList(snap.data);

                  return CategoryTable();
                
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
 
}
