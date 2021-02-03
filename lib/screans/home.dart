import 'package:flutter/material.dart';

import '../drawer.dart';

class HomeScrean extends StatefulWidget {
  @override
  _HomeScreanState createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('مخزنك'),
          ),
          drawer: MainDrawer(),
          body: Container(),
        ),
      ),
    );
  }
}
