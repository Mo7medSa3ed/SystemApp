import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../drawer.dart';

class HomeScrean extends StatefulWidget {
  @override
  _HomeScreanState createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  List<DateTime> picked = [];
  StoreData storeData;
  num a, b, c, d, e, f = 0;
  var controller = TextEditingController();
  List<Permission> permisionList;
    List<Permission> alldataList;
  num imports =0;
  num exports =0;
  num length =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermissions();
    storeData = Provider.of<StoreData>(context, listen: false);
    final l = storeData.userList;
    a = l.length;
    b = l.where((e) => e.role == 'عامل').toList().length;
    c = l.where((e) => e.role == 'مدير مخزن').toList().length;
    d = l.where((e) => e.role == 'امين مخزن').toList().length;
    e = storeData.productList.length;
    f = storeData.storeList.length;
  }

  getPermissions() async {
    print("adas");
    await API.getAllpermissions().then((value) {
      setState(() {
        permisionList = value;
        alldataList =value;
        getdata('lack');
        
      });
    });
  }
  getdata(type){
    num f=0;
    num a=0;
    permisionList.where((e) {
      if(e.type=='add'){
       f += e.sum; 
      }else{
        a+=e.sum; 
      }
    } ).toList();
    setState(() {
      exports=a;
      imports=f;
      length =permisionList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: white.withOpacity(0.95),
          appBar: AppBar(
            title: Text('مخزنك'),
          ),
          drawer: MainDrawer(),
          body: ListView(
            children: [
              cards(),
              buildChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget cards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            lonecard('موظف', a.toString(), Icons.people, true),
            lonecard('مدير مخزن', b.toString(), Icons.people, true),
            lonecard('امين مخزن', c.toString(), Icons.people, true)
          ],
        ),
        Row(
          children: [
            lonecard('عامل', d.toString(), Icons.people, true),
            lonecard('منتج', e.toString(), Icons.list, true),
            lonecard('مخزن', f.toString(), Icons.store, true)
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'الصادرات و الواردات :  ',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: black.withOpacity(0.75)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: buidPicker(),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Row(
          children: [
            buildCardsforstatistic('اﻷذونات', Icons.security, '0 اذن'),
            buildCardsforstatistic('الصادرات', Icons.outbox, '${exports} جنيه'),
            buildCardsforstatistic('الواردات', Icons.inbox, '${imports} جنيه'),
          ],
        )
      ],
    );
  }

  Widget buidPicker() {
    return TextFormField(
      controller: controller,
      onTap: () async => await showDatePicker(),
      readOnly: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(icon: Icon(Icons.close),onPressed: () {
              controller.clear();
              setState(() {
                permisionList=alldataList;
              });
            } ,),
          ),
          filled: true,
          hintText: 'اختر المدة التى تريد جردها',
          fillColor: white,
          border: OutlineInputBorder()),
    );
  }

  showDatePicker() async {
    await DateRagePicker.showDatePicker(
            context: context,
            initialFirstDate: new DateTime.now(),
            initialLastDate: new DateTime.now(),
            firstDate: new DateTime(2021),
            lastDate: new DateTime(2050))
        .then((value) {
      setState(() {
        picked = value;
      });
    });
    if (picked != null && picked.length == 2) {
      controller.text =
          'من:  ${picked[0].toString().substring(0, 10)}   الى :  ${picked[1].toString().substring(0, 10)}';
      dateRangeDataReturn(picked[0], picked[1]);
    } else {
      controller.clear();
      setState(() {
      permisionList = alldataList;
    });
    }
  }

  Widget lonecard(title, text, icon, test) {
    return Expanded(
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Kprimary,
                child: Icon(
                  icon,
                  color: white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  test
                      ? Text(
                          text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                          overflow: TextOverflow.visible,
                          softWrap: false,
                        )
                      : FutureBuilder<List<Product>>(
                          future: API.getAllProducts(),
                          builder: (c, s) => s.hasData
                              ? Text(
                                  s.data.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  overflow: TextOverflow.visible,
                                  softWrap: false,
                                )
                              : CircularProgressIndicator()),
                ],
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                overflow: TextOverflow.visible,
                softWrap: false,
              )
            ],
          ),
        ),
      ),
    );
  }

  buildChart() {
    return permisionList != null
        ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildChartLine('add'),
                  buildChartLine('lack'),
                ],
              ),
            ),
          )
        : Container(
          width: double.infinity,
          height: double.infinity,
          child: CircularProgressIndicator());
  }

  Widget buildChartLine(type) {
    // final l =s.data.map((e) => {e.created_at,e.sum}).toList();
    // print(l);

    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        // Chart title
        title:
            ChartTitle(text: type == 'add' ? 'جميع الواردات' : 'جميع الصادرات'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<Permission, DateTime>>[
          SplineSeries<Permission, DateTime>(
              dataSource: permisionList.where((e) => e.type == type).toList(),
              xValueMapper: (Permission sales, _) =>
                  DateTime.parse(sales.created_at),
              yValueMapper: (Permission sales, _) => sales.sum,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: true))
        ]);
  }

  dateRangeDataReturn(DateTime f, DateTime s) {
    final l = permisionList.where((e) {
      DateTime d = DateTime.parse(e.created_at);
      if(d.compareTo(f)==0|| d.compareTo(s)==0){
        return true;
      }else if( d.compareTo(s)<0 && f.compareTo(d)<0 ){
        return true;
      }else{
        return false;
      }

    }).toList();
    setState(() {
      permisionList = l;
    });
  }

  Widget buildCardsforstatistic(text, icon, amount) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                  Icon(
                    icon,
                    color: Kprimary,
                  )
                ],
              ),
              Divider(
                color: greyw,
              ),
              Text(
                amount,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
