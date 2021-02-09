import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/addcategory.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constants.dart';
import '../size_config.dart';
import '../widget.dart';

class ProductDialog {
  BuildContext context;
  ProductDialog({this.context});
  String productname, sellprice, buyprice, amount, category, storename;

  bool expanded = false;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();

  addproduct({Product p}) {
    SizeConfig().init(context);
    storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: p != null ? "تعديل منتج" : "اضف منتج",
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildTextFormField(
                      value: p != null ? p.productName : null,
                      onsaved: (v) => productname = v,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'اسم المنتج',
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: p != null ? p.buy_price.toString() : null,
                      onsaved: (v) => buyprice = v,
                      secure: false,
                      hint: 'اكتب سعر الشراء',
                      icon: Icons.monetization_on_outlined,
                      label: 'سعر الشراء',
                      keyboardType: TextInputType.number),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: p != null ? p.sell_price.toString() : null,
                      onsaved: (v) => sellprice = v,
                      secure: false,
                      icon: Icons.monetization_on_outlined,
                      hint: 'اكتب سعر البيع',
                      label: 'سعر البيع',
                      keyboardType: TextInputType.number),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  buildTextFormField(
                      value: p != null ? p.amount.toString() : null,
                      onsaved: (v) => amount = v,
                      secure: false,
                      hint: 'اكتب الكمية المتاحة',
                      label: 'الكمية',
                      keyboardType: TextInputType.number),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<StoreData>(
                          builder: (c, s, w) => buildDropDown(
                              expanded: expanded,
                              headertext: p != null
                                  ? getCategoryname(
                                      context: context, id: p.categoryId)
                                  : 'اختر الفئة',
                              list: s.categoryList.map((e) => e.name).toList(),
                              value: false),
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
                              onPressed: () => CategoryDialog(context: context)
                                  .addcategory())),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  buildDropDown(
                      expanded: expanded,
                      headertext: p != null
                          ? getStoreName(context: context, storeid: p.storeid)
                          : 'اختر المخزن',
                      list:
                          storeData.storeList.map((e) => e.storename).toList(),
                      value: true),
                  SizedBox(
                    height: getProportionateScreenHeight(25),
                  ),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            color: Kprimary,
            height: getProportionateScreenHeight(40),
            onPressed: () async {
              p != null ? await update(p) : await add();
            },
            child: Center(
              child: Text(
                p != null ? "تعديل منتج" : "اضف منتج",
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]).show();
  }

  Widget buildDropDown(
      {bool expanded, String headertext, List<String> list, bool value}) {
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
                          trailing: value
                              ? storename != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          storename = null;
                                          expanded = false;
                                        });
                                      },
                                    )
                                  : null
                              : category != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          category = null;
                                          expanded = false;
                                        });
                                      },
                                    )
                                  : null,
                          title: Text(value
                              ? storename != null
                                  ? storename
                                  : headertext
                              : category != null
                                  ? category
                                  : headertext))),
              body: Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => setstate(() {
                            value ? storename = e : category = e;
                            expanded = false;
                          }),
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  add() async {
    formKey.currentState.save();
    if (productname == null ||
        sellprice == null ||
        buyprice == null ||
        storename == null ||
        category == null ||
        amount == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);

      Product p = Product(
          productName: productname,
          amount: int.parse(amount.trim()),
          buy_price: double.parse(buyprice.trim()),
          sell_price: double.parse(sellprice.trim()),
          storeid: getStoreid(context: context, storename: storename),
          categoryId: getCategoryid(context: context, name: category));

      final res = await API.addProduct(p);
      if (res != null) {
        storeData.addProduct(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة منتج بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  update(Product p) async {
    formKey.currentState.save();
    if (storename == null) {
      storename = getStoreName(context: context, storeid: p.storeid);
    }
    if (category == null) {
      category = getCategoryname(context: context, id: p.categoryId);
    }

    if (productname == null ||
        sellprice == null ||
        buyprice == null ||
        storename == null ||
        category == null ||
        amount == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);

      Product product = Product(
          id: p.id,
          productName: productname,
          amount: int.parse(amount.trim()),
          buy_price: double.parse(buyprice.trim()),
          sell_price: double.parse(sellprice.trim()),
          storeid: getStoreid(context: context, storename: storename),
          categoryId: getCategoryid(context: context, name: category));

      final res = await API.updateProduct([product]);
      if (res != null) {
        product.created_at = DateTime.now().toString();
        storeData.updateProduct([product]);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم تعديل منتج بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  deleteproduct(Product p) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
        onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deleteProduct([p.id]);
          if (res.statusCode == 200) {
            storeData.deleteProduct([p]);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف المنتج بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }

  deleteProducts(List<num> product) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
        onpress: () async {
          Navigator.pop(context);
          showDialogWidget(context);
          storeData = Provider.of<StoreData>(context, listen: false);
          final res = await API.deleteProduct(product);
          if (res.statusCode == 200) {
            storeData.deleteManyOfProducts(product);
            Navigator.pop(context);
            Dialogs(context).successDilalog("تم حذف المنتحات بنجاح");
          } else {
            Navigator.pop(context);
            Dialogs(context).errorDilalog();
          }
        });
  }

  moveToStore(List<Product> produscts) async {
    if (storename == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      produscts.forEach((element) {
        element.storeid = getStoreid(context: context, storename: storename);
      });
      final res = await API.updateProduct(produscts);
      if (res.statusCode == 200) {
        storeData.updateProduct(produscts);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم نقل المنتجات بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  moveToStoreDialog(List<Product> produscts) {
    storeData = Provider.of<StoreData>(context, listen: false);
    SizeConfig().init(context);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: 'نقل لمخزن آخر',
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildDropDown(
                      expanded: expanded,
                      headertext: 'اختر المخزن المراد النقل اليه',
                      list:
                          storeData.storeList.map((e) => e.storename).toList(),
                      value: true),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            height: getProportionateScreenHeight(40),
            color: Kprimary,
            onPressed: () async {
              await moveToStore(produscts);
              storename = null;
            },
            child: Center(
              child: Text(
                'نقل',
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          )
        ]).show();
  }

  updateAmount(Product p, type) {
    SizeConfig().init(context);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: 'تعديل الكمية',
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildTextFormField(
                      value: p != null ? p.amount.toString() : null,
                      onsaved: (v) => amount = v,
                      secure: false,
                      hint: 'اكتب الكمية',
                      label: 'الكمية',
                      keyboardType: TextInputType.number),
                ],
              ),
            ),
          ),
        ),
        buttons: [
          DialogButton(
            height: getProportionateScreenHeight(40),
            color: Kprimary,
            onPressed: () => updateamount(type, p),
            child: Center(
              child: Text(
                'تعديل الكمية',
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          )
        ]).show();
  }

  updateamount(type, p) {
    formKey.currentState.save();
    storeData = Provider.of<StoreData>(context, listen: false);

    if (type != 'add') {
      Product p2 = storeData.productList.firstWhere((e) => e.id == p.id);

      if (int.parse(amount) <= p2.amount) {
        storeData.sum -= (p.amount * p.sell_price);
        p.amount = int.parse(amount.trim());
        storeData.updateproductTable(p);
        Navigator.pop(context);
        // Dialogs(context).successDilalog("تم تعديل المنتج بنجاح");
      } else {
        Navigator.pop(context);
        Dialogs(context)
            .warningDilalog2(msg: 'اقصى كمية يمكن صرفها ${p2.amount}');
      }
    } else {
      storeData.sum -= (p.amount * p.sell_price);
      p.amount = int.parse(amount.trim());
      storeData.updateproductTable(p);
      Navigator.pop(context);
    }
  }

  deleteProductfrontable(product) {
    storeData = Provider.of<StoreData>(context, listen: false);
    storeData.deleteproductTable(product);
  }

  deleteProductsTable(List<Product> product) {
    Dialogs(context).warningDilalog(
        msg: "هل انت متأكد من عملية الحذف؟",
        onpress: () async {
          storeData = Provider.of<StoreData>(context, listen: false);
          storeData.deleteManyOfproductsTable(product);
          Navigator.pop(context);
          Dialogs(context).successDilalog("تم حذف المنتحات بنجاح");
        });
  }
}
