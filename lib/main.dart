import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoreData>(
        create:(c)=> StoreData(),
        child: MaterialApp(
        title: 'مخزنك',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          accentColor: Kprimary,
          primaryColor: Kprimary,
          cursorColor: Kprimary,
        iconTheme: IconThemeData(
          color: white
        ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScrean(),
      ),
    );
  }
}


