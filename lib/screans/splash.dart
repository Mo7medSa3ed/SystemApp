import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/screans/login.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScrean extends StatefulWidget {
  @override
  _SplashScreanState createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  StoreData storeData;
  SharedPreferences prfs;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    storeData = Provider.of<StoreData>(context, listen: false);
    prfs = await SharedPreferences.getInstance();

    await API.getAllstores().then((value) => storeData.initStoreList(value));
    await API.getAllUsers().then((value) => storeData.initUserList(value));
    await API
        .getAllCategories()
        .then((value) => storeData.initCategoryList(value));
    await API
        .getAllcustomers()
        .then((value) => storeData.initcustomerList(value));
    await API
        .getAllProducts()
        .then((value) => storeData.initProductList(value));

    if (prfs.getString('user') != null) {
      User user = await getUserFromPrfs();
      User u = storeData.userList.firstWhere(
          (element) => element.created_at == user.created_at,
          orElse: () => null);
      if (u != null) {
        storeData.initLoginUser(u);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScrean()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
      }
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScrean()));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/store.png',
              height: getProportionateScreenHeight(100),
              width: getProportionateScreenWidth(100),
            ),
            SpinKitCircle(
              color: Theme.of(context).primaryColor,
              size: getProportionateScreenHeight(50),
            ),
          ],
        ),
      ),
    );
  }
}
