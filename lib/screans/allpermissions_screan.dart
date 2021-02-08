import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/tables/permissiontable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllPermissionsScrean extends StatelessWidget {
  StoreData storeData;
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text('جميع الآذونات'),
           
          ),
          drawer: MainDrawer(),
          body: FutureBuilder<List<Permission>>(
            future: API.getAllpermissions(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                storeData.initPermissionList(snap.data);

                return PermissionTable();
              
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
