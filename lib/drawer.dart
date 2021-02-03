import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screans/alluser_screan.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/size_config.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                    "Mohamed Saeed",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: white),
                  ),
                ],
              )),
          buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
          buildListTile(context, "جميع العمال", Icons.people, AllUserScrean()),
          buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
          buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
          buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
          buildListTile(context, "الرئيسية", Icons.home, HomeScrean()),
        ],
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
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
          },
      );
}
