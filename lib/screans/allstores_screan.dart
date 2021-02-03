import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addstore.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/tables/storetable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllStoresScrean extends StatelessWidget {
  StoreData storeData;
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text('جميع المخازن'),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 30,
                  ),
                  onPressed: () =>  Storesdialog(context: context).addstore()),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          drawer: MainDrawer(),
          body: FutureBuilder<List<User>>(
            future: API.getAllUsers(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                storeData.initUserList(snap.data);
                return StoreTable();
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
