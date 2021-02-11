import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcustomer.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/Customer.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/tables/customertable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllCustomerScrean extends StatelessWidget {
  StoreData storeData;
  final String type;
  final String title;
  AllCustomerScrean({this.type, this.title});

  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScrean()),
            (Route<dynamic> route) => false),
        child: Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 25,
                    ),
                    onPressed: () =>
                        CustomerDialog(context: context, type: type)
                            .addcustomer()),
                /* SizedBox(
                  width: 5,
                ), */
              ],
            ),
            drawer: MainDrawer(),
            body: FutureBuilder<List<Customer>>(
              future: API.getAllcustomers(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initcustomerList(snap.data);

                  return CustomerTable(
                    type: type,
                  );
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
