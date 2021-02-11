import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcustomer.dart';
import 'package:flutter_app/dialogs/addproduct.dart';
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
import 'package:flutter_app/screans/home.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/tables/pertable.dart';
import 'package:flutter_app/widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

class AddpPermissionScrean extends StatelessWidget {
  String type;

  AddpPermissionScrean({
    this.type,
  });

  StoreData storeData;
  Specials specials;

  Customer customer;

  Store store;

  int amount = 0;
  bool sw = false;
  num finalPrice = 0.0;
  bool expanded = false;
  String paidMoney;
  String discount = '0';
  Product product;
  List<Product> productList = [];
  var controller = TextEditingController();

  var amountController = TextEditingController(text: '0');
  var scrollController = ScrollController();

  reset() {
    storeData.productTableList = [];
    specials.productselected = false;
    storeData.sum = 0.0;
    storeData.paid = false;
  }

  @override
  Widget build(BuildContext context) {
    storeData = Provider.of<StoreData>(context, listen: false);
    specials = Provider.of<Specials>(context, listen: false);
    print("asds");
    return WillPopScope(
      onWillPop: () {
        reset();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => HomeScrean()),
            (Route<dynamic> route) => false);
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
                  productList = snap.data;

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
      padding: EdgeInsets.fromLTRB(5, 0, 5, 8),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
        buildaddbutton(() => CustomerDialog(
                context: context, type: type != 'add' ? 'عميل' : 'مورد')
            .addcustomer())
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

  buildaddbutton(onpressed) {
    /* return  Container(
        width: 60,
       padding:  EdgeInsets.only(bottom: getProportionateScreenHeight(0)),
       child: IconButton(icon: Icon(Icons.add_box,color: Kprimary,size: getProportionateScreenHeight(50),), onPressed:onpressed )
     );
 */
    return Container(
        margin: EdgeInsets.only(right: 5.0),
        height: getProportionateScreenHeight(45),
        width: getProportionateScreenWidth(52),
        alignment: Alignment.center,
        child: RaisedButton(
            color: Kprimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Center(
                child: Icon(
              Icons.add,
              size: 18,
              color: white,
            )),
            onPressed: onpressed));
  }

  Widget typeHead(context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer<StoreData>(
              builder: (_, v, c) => AutoCompleteTextField<Product>(
                controller: controller,
                clearOnSubmit: false,
                suggestions: v.productList,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenWidth(10)),
                    filled: true,
                    fillColor: white,
                    hintText: 'ابحث عن المنتج....',
                    border: OutlineInputBorder()),
                itemFilter: (Product p, String s) => p.productName
                    .toLowerCase()
                    .trim()
                    .contains(s.toLowerCase().trim()),
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
              ),
            ),
          ),
          type == 'add'
              ? buildaddbutton(
                  () => ProductDialog(context: context).addproduct())
              : Container()
        ]);
  }

  Widget add_lackbutton(context) {
    return Consumer<Specials>(
      builder: (_, v, c) => Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(right: 5.0),
                    height: getProportionateScreenHeight(45),
                    width: getProportionateScreenWidth(55),
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
                          size: 20,
                          color: white,
                        )),
                        onPressed: () {
                          if (v.productselected) {
                            if (type == 'lack') {
                              if (amount >= 0 && amount < product.amount) {
                                amount++;
                                amountController.text = amount.toString();
                              } else {
                                Dialogs(context).warningDilalog2(
                                    msg:
                                        'اقصى كمية يمكن صرفها ${product.amount}');
                              }
                            } else {
                              if (amount >= 0) {
                                amount++;
                                amountController.text = amount.toString();
                              }
                            }
                          }
                        })),
                Container(
                    // height: 55,
                    margin: EdgeInsets.only(right: 5, left: 5),
                    width: getProportionateScreenWidth(90),
                    alignment: Alignment.center,
                    child: TextField(
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                      controller: amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                    )),
                Container(
                    margin: EdgeInsets.only(right: 5.0),
                    height: getProportionateScreenHeight(45),
                    width: getProportionateScreenWidth(55),
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
                          size: 20,
                          color: white,
                        )),
                        onPressed: () {
                          if (v.productselected) {
                            if (amount > 0) {
                              amount--;
                              amountController.text = amount.toString();
                            }
                          }
                        })),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (v) {
                      discount = v;
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(5),
                            horizontal: getProportionateScreenWidth(5)),
                        suffixIcon: Icon(Icons.monetization_on),
                        hintText: 'الخصم',
                        border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              width: double.infinity,
              child: RaisedButton(
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
              ),
            )
          ],
        ),
      ),
    );
  }

  void addtoTableMethod(context) {
    product.discount =
        (discount == null || discount.isEmpty) ? 0 : double.parse(discount);
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
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(5), vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'السعر النهائى',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        value.sum.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: getProportionateScreenHeight(60),
                    margin: EdgeInsets.fromLTRB(getProportionateScreenWidth(8),
                        0, getProportionateScreenWidth(8), 0),
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(10)),
                          suffixIcon: Icon(Icons.monetization_on),
                          hintText: 'المبلغ المدفوع',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: FlutterSwitch(
                      height: 40,
                      activeColor: Kprimary,
                      activeText: "نقدى",
                      inactiveText: "آجل",
                      value: value.paid,
                      valueFontSize: 12.0,
                      width: getProportionateScreenWidth(70),
                      borderRadius: 30.0,
                      showOnOff: true,
                    ),
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
    if (customer == null) {
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
          .map((e) => (e.added && e.id == 0)
              ? ProductBackup(
                  productId: 0,
                  discount: e.discount,
                  productName: e.productName,
                  amount: e.amount,
                  buy_price: e.buy_price,
                  sell_price: e.sell_price,
                  storeid: e.storeid,
                  categoryId: e.categoryId)
              : ProductBackup(productId: e.id, amount: e.amount))
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
        reset();
      } else {
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }
}

//async => await makePermission(context)
