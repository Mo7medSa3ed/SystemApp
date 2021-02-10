import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcustomer.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/drawer.dart';
import 'package:flutter_app/models/Customer.dart';
import 'package:flutter_app/models/CustomerBackeup.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/tables/pertable.dart';
import 'package:flutter_app/widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class AddpPermissionScrean extends StatelessWidget {
  String type;

  AddpPermissionScrean({this.type});

  StoreData storeData;
  Specials specials;

  Customer customer;

  Store store;

  int amount = 0;
  bool sw = false;
  num finalPrice = 0.0;
  bool expanded = false;
  String paidMoney;
  Product product;

  var controller = TextEditingController();

  var amountController = TextEditingController(text: '0');
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    specials = Provider.of<Specials>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        storeData.productTableList = [];
        specials.productselected = false;
        storeData.sum = 0.0;
        storeData.paid = false;
        Navigator.of(context).pop();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text(type != 'add' ? 'اذن صرف' : 'اذن اضافة'),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Selector<Specials, bool>(
                selector: (c, s) => s.scroll,
                builder: (_, v, c) => FloatingActionButton(
                  backgroundColor: Kprimary.withOpacity(0.7),
                  child: Icon(v ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: () {
                    scrollController.animateTo(
                        v
                            ? scrollController.position.minScrollExtent
                            : scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                    specials.changescroll(!v);
                  },
                ),
              ),
            ),
            drawer: MainDrawer(),
            body: FutureBuilder<List<Product>>(
              future: API.getAllProducts(),
              builder: (ctx, snap) {
                if (snap.hasData) {
                  storeData.initProductList(snap.data);

                  return Body(context);
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

  Widget Body(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      width: double.infinity,
      child: ListView(
        controller: scrollController,
        children: [
          buildmoneyRow(),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          row(context),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          typeHead(context),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          add_lackbutton(context),
          SizedBox(
            height: getProportionateScreenHeight(5),
          ),
          PerTable(
            type: type,
          ),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          Consumer<StoreData>(
            builder: (_, val, c) => buildRaisedButton(
              color: val.productTableList.length > 0
                  ? Kprimary
                  : Kprimary.withOpacity(0.3),
              text: 'انشاء الإذن',
              pressed: () async => await makePermission(context),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
        ],
      ),
    );
  }

  Row row(context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<StoreData>(
            builder: (c, s, w) => buildDropDown(
              expanded: expanded,
              headertext: type != 'add' ? 'اختر عميل' : 'اختر مورد',
              i: 0,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(right: 5.0, bottom: 1),
            height: 64,
            width: 78,
            alignment: Alignment.center,
            child: RaisedButton(
                color: Kprimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                    child: Icon(
                  Icons.add,
                  size: 30,
                  color: white,
                )),
                onPressed: () => CustomerDialog(
                        context: context, type: type != 'add' ? 'عميل' : 'مورد')
                    .addcustomer())),
      ],
    );
  }

  Widget buildDropDown({bool expanded, String headertext, int i}) {
    return StatefulBuilder(
      builder: (ctx, setstate) => Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: expanded ? Kprimary : grey, width: expanded ? 2 : 1.2),
            borderRadius: BorderRadius.circular(4)),
        child: new ExpansionPanelList(
          elevation: 0,
          expansionCallback: (int index, bool status) {
            setstate(() => expanded = !expanded);
          },
          children: [
            new ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: expanded,
              headerBuilder: (BuildContext context, bool isExpanded) =>
                  new Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: ListTile(
                          trailing: customer != null
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setstate(() {
                                      customer = null;
                                      expanded = false;
                                    });
                                  },
                                )
                              : null,
                          title: Text(i == 0
                              ? customer != null
                                  ? customer.name
                                  : headertext
                              : store != null
                                  ? store.storename
                                  : headertext))),
              body: Column(
                children:
                    (i == 0 ? storeData.customerList : storeData.storeList)
                        .map((dynamic e) => ListTile(
                              onTap: () => setstate(() {
                                i == 0 ? customer = e : store = e;
                                expanded = false;
                              }),
                              title: Text(i == 0 ? e.name : e.storename),
                            ))
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeHead(context) {
    return AutoCompleteTextField(
      controller: controller,
      clearOnSubmit: false,
      suggestions: storeData.productList,
      decoration: InputDecoration(
          filled: true,
          fillColor: white,
          hintText: 'ابحث عن المنتج....',
          border: OutlineInputBorder()),
      itemFilter: (Product p, String s) =>
          p.productName.toLowerCase().trim().contains(s.toLowerCase().trim()),
      itemSubmitted: (Product p) {
        controller.text = p.productName;
        product = Product(
          id: p.id,
          amount: p.amount,
          buy_price: p.buy_price,
          categoryId: p.categoryId,
          created_at: p.created_at,
          productName: p.productName,
          sell_price: p.sell_price,
          storeid: p.storeid,
        );
        specials.changeProdutcSelected(true);
      },
      itemSorter: (a, b) => a.toString().compareTo(b.toString()),
      itemBuilder: (_, Product item) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Text(item.productName),
      ),
    );
  }

  Widget add_lackbutton(context) {
    return Consumer<Specials>(
      builder: (_, v, c) => Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 5.0, bottom: 1),
                height: 55,
                width: 65,
                alignment: Alignment.center,
                child: RaisedButton(
                    color: v.productselected
                        ? Kprimary
                        : Kprimary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Icon(
                      Icons.add,
                      size: 28,
                      color: white,
                    )),
                    onPressed: () {
                      if (type == 'lack') {
                        print(product.amount);
                        if (amount >= 0 && amount < product.amount) {
                          amount++;
                          amountController.text = amount.toString();
                        } else {
                          Dialogs(context).warningDilalog2(
                              msg: 'اقصى كمية يمكن صرفها ${product.amount}');
                        }
                      } else {
                        if (amount >= 0) {
                          amount++;
                          amountController.text = amount.toString();
                        }
                      }
                    })),
            Container(
                // height: 55,
                margin: EdgeInsets.only(right: 5, left: 5),
                width: 140,
                alignment: Alignment.center,
                child: TextField(
                  style: TextStyle(
                      color: black, fontWeight: FontWeight.w700, fontSize: 20),
                  controller: amountController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(border: InputBorder.none),
                )),
            Container(
                margin: EdgeInsets.only(right: 5.0, bottom: 1),
                height: 55,
                width: 65,
                alignment: Alignment.center,
                child: RaisedButton(
                    color: v.productselected
                        ? Kprimary
                        : Kprimary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Icon(
                      Icons.remove,
                      size: 25,
                      color: white,
                    )),
                    onPressed: () {
                      print(amount);
                      if (amount > 0) {
                        amount--;
                        amountController.text = amount.toString();
                      }
                    })),
            Spacer(),

            // updat
            RaisedButton(
              color: v.productselected ? Kprimary : Kprimary.withOpacity(0.3),
              onPressed: () {
                if (amount == 0) {
                  Dialogs(context)
                      .warningDilalog2(msg: ' !!ادخل الكمية المطلوبة');
                } else if (product != null) {
                  if (amount > product.amount && type != 'add') {
                    Dialogs(context).warningDilalog2(
                        msg: 'اقصى كمية يمكن صرفها ${product.amount}');
                    return;
                  } else if (type != 'add') {
                    final p = storeData.productTableList.firstWhere(
                        (e) => e.id == product.id,
                        orElse: () => null);
                    if (p != null) {
                      if ((p.amount + amount) > product.amount) {
                        Dialogs(context).warningDilalog2(
                            msg: 'اقصى كمية يمكن صرفها ${product.amount}');
                        return;
                      } else {
                        addtoTableMethod(context);
                      }
                    } else {
                      addtoTableMethod(context);
                    }
                  } else {
                    addtoTableMethod(context);
                  }
                } else {
                  Dialogs(context)
                      .warningDilalog2(msg: '!! برجاء اختيار منتج ع الأقل ');
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                'اضف للجدول',
                style: TextStyle(color: white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addtoTableMethod(context) {
    storeData.addproductTable(amount, product, context);
    specials.changeProdutcSelected(false);
    product = null;
    controller.clear();
    amountController.text = '0';
    amount = 0;
  }

  Widget buildmoneyRow() {
    return Consumer<StoreData>(
      builder: (context, value, child) => Container(
        child: Card(
          elevation: 3,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'السعر النهائى',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      value.sum.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (v) {
                        paidMoney = v;
                        if (int.parse(paidMoney) < storeData.sum) {
                          storeData.changepaid(false);
                        } else {
                          storeData.changepaid(true);
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.monetization_on),
                          hintText: 'المبلغ المدفوع',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: FlutterSwitch(
                    height: 40,
                    activeColor: Kprimary,
                    activeText: "نقدى",
                    inactiveText: "آجل",
                    value: value.paid,
                    valueFontSize: 12.0,
                    width: 90,
                    borderRadius: 30.0,
                    showOnOff: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makePermission(context) async {
    print(customer.name);
    print(store.storename);

    if (customer == null || store == null) {
      return Dialogs(context).infoDilalog();
    } else if (storeData.productTableList.length == 0) {
      return Dialogs(context).warningDilalog2(msg: '!! لم يتم اضافة منتجات');
    } else if (storeData.paid &&
        (paidMoney == null || int.parse(paidMoney) == 0)) {
      return Dialogs(context)
          .warningDilalog2(msg: '!! برجاء ادخال المبلغ المدفوع');
    } else {
      showDialogWidget(context);
      User u = storeData.loginUser;
      UserBackup us =
          UserBackup(username: u.username, role: u.role, password: u.password);
      List<ProductBackup> items = storeData.productTableList
          .map((e) => ProductBackup(productId: e.id, amount: e.amount))
          .toList();

      CustomerBackeup c = CustomerBackeup(
          type: customer.type,
          address: customer.address,
          customerId: customer.id,
          name: customer.name,
          phone: customer.phone);
      Permission p = Permission(
        
        customer: c,
          paidMoney: sw ? int.parse(paidMoney.trim()) : 0,
          paidType: sw ? 'نقدى' : 'آجل',
          type: type,
          user: us,
          items: items);
      final res = await API.addPermission(p);
      if (res.statusCode == 200) {
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم عمل الإذن بنجاح ");
      } else {
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }
}
