import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/category.dart';
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
  String productname, sellprice, buyprice, amount, storename;
  Categorys categorys;
  List<Categorys> categoriesList = [];
  bool expanded = false;
  String name;
  StoreData storeData;
  final formKey = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();


  addproduct({Product p}) {
    SizeConfig().init(context);
    categoriesList = [];
    storeData = Provider.of<StoreData>(context, listen: false);
    categoriesList = storeData.categoryList;
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
              child: SingleChildScrollView(
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
                    autoComplete(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    buildDropDown(
                        expanded: expanded,
                        headertext: p != null
                            ? getStoreName(context: context, storeid: p.storeid)
                            : 'اختر المخزن',
                        list: storeData.storeList
                            .map((e) => e.storename)
                            .toList(),
                        value: true),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                  ],
                ),
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

  Widget autoComplete() {
    return Row(
      children: [
        Expanded(
          child: AutoCompleteTextField<Categorys>(
            //controller: controller,
            clearOnSubmit: false,
            suggestions: categoriesList,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                filled: true,
                fillColor: white,
                hintText: 'ابحث عن فئة ....',
                border: OutlineInputBorder()),
            itemFilter: (Categorys p, String s) =>
                p.name.toLowerCase().trim().contains(s.toLowerCase().trim()),
            itemSubmitted: (Categorys p) {
              categorys = Categorys(
                  id: p.id,
                  created_at: p.created_at,
                  name: p.name,
                  productslength: p.productslength);
            },
            itemSorter: (a, b) => a.toString().compareTo(b.toString()),
            itemBuilder: (_, Categorys item) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(item.name),
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
                onPressed: () => addcategory())),
        //
      ],
    );
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
                              : categorys != null
                                  ? IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        setstate(() {
                                          categorys = null;
                                          expanded = false;
                                        });
                                      },
                                    )
                                  : null,
                          title: Text(value
                              ? storename != null
                                  ? storename
                                  : headertext
                              : categorys != null
                                  ? categorys
                                  : headertext))),
              body: Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => setstate(() {
                            value ? storename = e : categorys.name = e;
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

  addcategory({Categorys category}) {
    SizeConfig().init(context);
    storeData = Provider.of<StoreData>(context, listen: false);
    return Alert(
        context: context,
        closeIcon: Icon(
          Icons.close,
          color: black,
          size: 24,
        ),
        title: category != null ? "تعديل فئة" : "اضف فئة",
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Form(
              key: formKey2,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  buildTextFormField(
                      value: category != null ? category.name : null,
                      onsaved: (v) => name = v,
                      secure: false,
                      hint: 'اكتب الاسم',
                      label: 'اسم الفئة',
                      keyboardType: TextInputType.text),
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
              await addcategorys();
            },
            child: Center(
              child: Text(
                category != null ? "تعديل فئة" : "اضف فئة",
                style: TextStyle(color: white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ]).show();
  }

  addcategorys() async {
    formKey2.currentState.save();
    if (name == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);
      Categorys category = Categorys(productslength: 0.0, name: name);
      final res = await API.addCategory(category);
      if (res != null) {
        categoriesList.add(res);
        storeData.addCategory(res);
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).successDilalog("تم اضافة فئة بنجاح");
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Dialogs(context).errorDilalog();
      }
    }
  }

  add() async {
    formKey.currentState.save();
    if (productname == null ||
        sellprice == null ||
        buyprice == null ||
        storename == null ||
        categorys == null ||
        amount == null) {
      return Dialogs(context).infoDilalog();
    } else {
      showDialogWidget(context);
      storeData = Provider.of<StoreData>(context, listen: false);

      Product p = Product(
          id: 0,
          productName: productname,
          amount: int.parse(amount.trim()),
          buy_price: double.parse(buyprice.trim()),
          sell_price: double.parse(sellprice.trim()),
          storeid: getStoreid(context: context, storename: storename),
          categoryId: categorys.id);
      p.added = true;
      storeData.addProduct(p);
      storeData.addproductTable(p.amount, p, context);
      Navigator.pop(context);
      Navigator.pop(context);
      Dialogs(context).successDilalog("تم اضافة منتج بنجاح");
    }
  }

  update(Product p) async {
    formKey.currentState.save();
    if (storename == null) {
      storename = getStoreName(context: context, storeid: p.storeid);
    }
    if (categorys == null) {
      categorys = Categorys(id: p.id);
    }

    if (productname == null ||
        sellprice == null ||
        buyprice == null ||
        storename == null ||
        categorys == null ||
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
          categoryId: categorys.id);

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
