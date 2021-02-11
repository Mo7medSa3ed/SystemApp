import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/tables/allbacks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllBacksPageScrean extends StatelessWidget {
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
              title: Text('جميع المرتجعات'),
             
            ),
            drawer: MainDrawer(),
            body: FutureBuilder<List<Back>>(
              future: API.getAllbacks(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initbackList(snap.data);
                  return AllBacksTable();
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
