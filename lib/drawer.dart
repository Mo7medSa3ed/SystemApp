import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/addpermission.dart';
import 'package:flutter_app/screans/allbacks_screan.dart';
import 'package:flutter_app/screans/allbackspage_screan.dart';
import 'package:flutter_app/screans/allcategories_screan.dart';
import 'package:flutter_app/screans/allcustomers_screan.dart';
import 'package:flutter_app/screans/allpermissions_screan.dart';
import 'package:flutter_app/screans/allproducts_screan.dart';
import 'package:flutter_app/screans/allstores_screan.dart';
import 'package:flutter_app/screans/alluser_screan.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/screans/login.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreData s = Provider.of<StoreData>(context, listen: false);
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Kprimary),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/store.png',
                      height: getProportionateScreenHeight(50),
                    ),
                    Text(
                      s.loginUser.username + '\n' + s.loginUser.role,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                  ],
                )),
            buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
            buildListTile(
                context, "جميع المخازن", Icons.store, AllStoresScrean()),
            buildListTile(
                context, "جميع العمال", Icons.people, AllUserScrean()),
            buildListTile(context, "جميع العملاء", Icons.people,
                AllCustomerScrean(type: 'عميل', title: "جميع العملاء")),
            buildListTile(
                context,
                "جميع الموردين",
                Icons.people,
                AllCustomerScrean(
                  type: "مورد",
                  title: "جميع الموردين",
                )),
            buildListTile(
                context, "جميع الفئات", Icons.category, AllCategoriesScrean()),
            buildListTile(context, "جميع المنتجات", Icons.list_alt_rounded,
                AllProductScrean()),
            buildListTile(context, "جميع الآذونات", Icons.security,
                AllPermissionsScrean()),
            buildListTile(
                context, "جميع المرتجعات", Icons.backup, AllBacksPageScrean()),
            buildListTile(
                context,
                "اذن اضافة",
                Icons.add_moderator,
                AddpPermissionScrean(
                  type: 'add',
                )),
            buildListTile(
                context,
                "اذن صرف",
                Icons.remove_moderator,
                AddpPermissionScrean(
                  type: 'lack',
                )),
            buildListTile(context, "اذن مرتجعات", Icons.settings_backup_restore,
                AllBacksScrean()),
            ListTile(
              title: Text(
                "تسجيل خروج",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(
                Icons.logout,
                color: Kprimary,
              ),
              onTap: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                sh.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScrean()),
                    (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, text, icon, page) => ListTile(
        title: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: Icon(
          icon,
          color: Kprimary,
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => page));
        },
      );
}
