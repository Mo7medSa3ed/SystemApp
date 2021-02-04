import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/provider/specials.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoreData>(
          create: (context) => StoreData(),
        ),
        ChangeNotifierProvider<Specials>(
          create: (context) => Specials(),
        ),
      ],
      child: MaterialApp(
        title: 'مخزنك',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          accentColor: Kprimary,
          primaryColor: Kprimary,
          cursorColor: Kprimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScrean(),
      ),
    );
  }
}
