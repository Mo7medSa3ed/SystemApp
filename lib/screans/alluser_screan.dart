import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/adduser.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/tables/usertable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../drawer.dart';

class AllUserScrean extends StatelessWidget {
  StoreData storeData;
  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child:WillPopScope(
        onWillPop: () =>  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScrean()),
                    (Route<dynamic> route) => false),
              child: Scaffold(
            appBar: AppBar(
              title: Text('جميع العمال'),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 30,
                    ),
                    onPressed: () => Usersdialog(context: context).addUser()),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
             drawer: MainDrawer(),
            floatingActionButton: buildSpeedDial(context),
            body: FutureBuilder<List<User>>(
              future: API.getAllUsers(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initUserList(snap.data);
         
                       return UsersTable();
          
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
                final List<num> list = storeData.userList
                    .where((element) => element.selected)
                    .toList()
                    .map((e) => e.id).toList(); 
                   
                list.length>0?Usersdialog(context: context).deleteUsers(list):Dialogs(context).warningDilalog2(msg:"!! برجاء اختيار عامل ع الأقل");
              },
              label: 'حذف  ',
              labelStyle: TextStyle(fontWeight: FontWeight.w500, color: white),
              labelBackgroundColor: Colors.deepOrangeAccent,
            ),
            SpeedDialChild(
              child: Icon(Icons.move_to_inbox, color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () {
                List<User> list = storeData.userList
                    .where((element) => element.selected)
                    .toList();
                     list.length>0?Usersdialog(context: context).moveToStoreDialog(list):Dialogs(context).warningDilalog2(msg:"!! برجاء اختيار عامل ع الأفل");
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
