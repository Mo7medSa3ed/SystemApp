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
  num imports = 0;
  num exports = 0;
  num length = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpermisionList();
  }

  getpermisionList() async {
    await API.getAllpermissions().then((value) {
      setState(() {
        permisionList = value;
        alldataList = value;
        //  getdata('add');
        filterdata('add');
        filterdata('lack');
      });
    });
  }

  /* num getdata(type) {
    imports = 0;
    exports = 0;
    permisionList.forEach((e) {
      if (e.type == 'add') {
        exports += e.sum;
      } else {
        imports += e.sum;
      }
    });
    return type == 'add' ? imports : exports;
  } */

  data() {
    storeData = Provider.of<StoreData>(context, listen: true);
    final l = storeData.userList;
    a = l.length;
    b = storeData.customerList.where((e) => e.type == 'عميل').length;
    c = storeData.customerList.where((e) => e.type != 'عميل').length;
    d = storeData.categoryList.length;
    e = storeData.productList.length;
    f = storeData.storeList.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        
        backgroundColor: white.withOpacity(0.95),
        appBar: AppBar(
          title: Text('مخزنك'),
        ),
        drawer: MainDrawer(),
        body: RefreshIndicator(
          onRefresh: () => Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeScrean())),
          child: ListView(
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
            lonecard('عميل', b.toString(), Icons.people, true),
            lonecard('مورد', c.toString(), Icons.people, true)
          ],
        ),
        Row(
          children: [
            lonecard('مخزن', f.toString(), Icons.store, true),
            lonecard('فئة', d.toString(), Icons.category, true),
            lonecard('منتج', e.toString(), Icons.grid_on, true),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
      ],
    );
  }

  Widget buidPicker() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 2, 8),
          child: CircleAvatar(
            backgroundColor: Kprimary,
            child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: white,
                ),
                onPressed: () {
                  controller.clear();
                  setState(() {
                    permisionList = alldataList;
                    filterdata('add');
                    filterdata('lack');
                  });
                }),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            onTap: () async => await showDatePicker(),
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(6),
                    horizontal: getProportionateScreenWidth(10)),
                filled: true,
                hintText: 'اختر المدة التى تريد جردها',
                fillColor: white,
                border: OutlineInputBorder()),
          ),
        ),
      ],
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
        filterdata('add');
        filterdata('lack');
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
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(6)),
                child: Text(
                  'الصادرات و الواردات :  ',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: black.withOpacity(0.75)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                child: buidPicker(),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(4)),
                child: Row(
                  children: [
                    buildCardsforstatistic('اﻷذونات', Icons.security,
                        '${permisionList.length} اذن'),
                    buildCardsforstatistic('الصادرات', Icons.outbox,
                        '${filterdata('lack').length > 0 ? filterdata('lack')[0].sum : 0} جنيه'),
                    buildCardsforstatistic('الواردات', Icons.inbox,
                        '${filterdata('add').length > 0 ? filterdata('add')[0].sum : 0} جنيه'),
                  ],
                ),
              ),
              Padding(
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
              ),
            ],
          )
        : Container(
            alignment: Alignment.center,
            height: 400,
            width: double.infinity,
            child: Center(child: CircularProgressIndicator()));
  }

  Widget buildChartLine(type) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        // Chart title
        title:
            ChartTitle(text: type == 'add' ? 'جميع الواردات' : 'جميع الصادرات'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<Chartdata, DateTime>>[
          ColumnSeries<Chartdata, DateTime>(
              color: type == 'add' ?  Kprimary :Color.fromRGBO(248,121,121,1),
              dataSource: filterdata(type),
              xValueMapper: (Chartdata sales, _) => DateTime.parse(sales.day),
              yValueMapper: (Chartdata sales, _) => sales.sum,
              name: 'Sales',
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: true))
        ]);
  }

  List<Chartdata> filterdata(type) {
    num s = 0;
    List<Chartdata> chartdataList = [];
    List<Permission> addlist = [];
    List<Permission> lacklist = [];

    if (type == 'add') {
      addlist = permisionList.where((element) => element.type == type).toList();
      final l =
          addlist.map((e) => e.created_at.substring(0, 10)).toSet().toList();

      l.forEach((e) {
        addlist.forEach((c) {
          if (e == (c.created_at.substring(0, 10))) {
            s += c.sum;
          }
        });
        chartdataList.add(Chartdata(day: e, sum: s));
        s = 0;
      });
    } else {
      lacklist =
          permisionList.where((element) => element.type == type).toList();
      final l =
          lacklist.map((e) => e.created_at.substring(0, 10)).toSet().toList();

      l.forEach((e) {
        lacklist.forEach((c) {
          if (e == (c.created_at.substring(0, 10))) {
            s += c.sum;
          }
        });
        s = 0;
        chartdataList.add(Chartdata(day: e, sum: s));
      });
    }

    return chartdataList;
  }

  dateRangeDataReturn(DateTime f, DateTime s) {
    final l = permisionList.where((e) {
      DateTime d = DateTime.parse(e.created_at);
      if (d.compareTo(f) == 0 || d.compareTo(s) == 0) {
        return true;
      } else if (d.compareTo(s) < 0 && f.compareTo(d) < 0) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      permisionList = l;
      filterdata('add');
      filterdata('lack');
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
                    size: 20,
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

class Chartdata {
  String day;
  num sum;
  Chartdata({this.day, this.sum});
}
