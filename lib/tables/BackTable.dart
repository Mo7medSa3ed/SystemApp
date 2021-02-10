import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_app/widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BackTable extends StatefulWidget {
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<BackTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var pds;
  var _controller = TextEditingController();
  var controller = TextEditingController();
  Permission p;
  StoreData storeData;
  getData() {
    List<ProductBackup> list = p.items;
    pds = PDS(
        context: context,
        productList: list,
        filterproductList: list,
        permission: p);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeData = Provider.of<StoreData>(context, listen: false);
  }

  void _sort<T>(
    Comparable<T> Function(BackProduct d) getField,
    int columnIndex,
    bool ascending,
  ) {
    pds._sort<T>(getField, ascending);
    setState(() {
      // [RestorableBool]'s value cannot be null, so -1 is used as a placeholder
      // to represent `null` in [DataTable]s.
      if (columnIndex == null) {
        _sortColumnIndex = -1;
      } else {
        _sortColumnIndex = columnIndex;
      }
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    p != null ? getData() : null;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            typeHead(context),
            p != null
                ? Column(
                    children: [
                      PaginatedDataTable(
                        rowsPerPage: _rowsPerPage,
                        onRowsPerPageChanged: (value) {
                          setState(() {
                            _rowsPerPage = value;
                          });
                        },
                        header: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: getProportionateScreenHeight(40),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: greyw,
                                    borderRadius: BorderRadius.circular(10)),
                                child: buildTextField(),
                              ),
                            ),
                          ],
                        ),
                        sortColumnIndex:
                            _sortColumnIndex == -1 ? null : _sortColumnIndex,
                        sortAscending: _sortAscending,
                        showCheckboxColumn: false,
                        source: pds,
                        columns: [
                          DataColumn(
                            label: Text('Id'),
                            numeric: true,
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => d.product.productId,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: Text('اسم المنتج'),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.product.productName,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text('الفئة'),
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => d.product.categoryId,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text('سعر البيع '),
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => d.product.sell_price,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text('سعر الشراء '),
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => d.product.buy_price,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: Text('الكمية'),
                            onSort: (columnIndex, ascending) => _sort<num>(
                                (d) => d.product.amount,
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: Text('المخزن'),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => getStoreName(
                                    context: context, storeid: d.product.storeid),
                                columnIndex,
                                ascending),
                          ),
                          DataColumn(
                            label: Text('تاريخ الإٍشتراك'),
                            onSort: (columnIndex, ascending) => _sort<String>(
                                (d) => d.product.created_at,
                                columnIndex,
                                ascending),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 15),
                        child: buildRaisedButton(
                            color: Kprimary,
                            text: 'انشاء الإذن',
                            pressed: () async => await pds.makeBackPer()),
                      )
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget typeHead(context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AutoCompleteTextField<Permission>(
        controller: controller,
        clearOnSubmit: false,
        suggestions: storeData.permissionList,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => controller.clear(),
              ),
            ),
            filled: true,
            fillColor: white,
            hintText: 'ابحث برقم الفاتورة....',
            border: OutlineInputBorder()),
        itemFilter: (Permission b, String s) {
          return b.id == int.parse(s.trim());
        },
        itemSubmitted: (Permission pb) {
          controller.text = pb.id.toString();
          setState(() {
            p = pb;
          });
        },
        itemSorter: (a, b) => a.toString().compareTo(b.toString()),
        itemBuilder: (_, Permission item) => Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(
            item.id.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    Specials s = Provider.of<Specials>(context, listen: false);
    return Selector<Specials, bool>(
        selector: (_, m) => m.istextempty,
        builder: (_, data, c) {
          return TextField(
            controller: _controller,
            onChanged: (v) {
              if (v.trim() == "") {
                pds.filter("-1");
                s.changeIsEmpty(true);
                _controller.clear();
              } else {
                pds.filter(v.trim());
                s.changeIsEmpty(false);
              }
            },
            cursorColor: Kprimary,
            decoration: InputDecoration(
                suffixIcon: data
                    ? Icon(Icons.search)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          pds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: 'بحث باسم المنتج ...',
                border: InputBorder.none),
          );
        });
  }
}

class PDS extends DataTableSource {
  List<ProductBackup> productList;
  List<ProductBackup> filterproductList;
  Permission permission;
  BuildContext context;

  PDS(
      {this.productList,
      this.context,
      this.filterproductList,
      this.permission});
  final formKey = GlobalKey<FormState>();
  @override
  DataRow getRow(int index) {
    final product = productList[index];
    return DataRow.byIndex(
      cells: [
        DataCell(Text(product.productId.toString())),
        DataCell(Text(product.productName)),
        DataCell(
            Text(getCategoryname(context: context, id: product.categoryId))),
        DataCell(Center(child: Text(product.sell_price.toString()))),
        DataCell(Center(child: Text(product.buy_price.toString()))),
        DataCell(Center(child: Text(product.amount.toString())),
            showEditIcon: true, onTap: () => updateAmount(product)),
        DataCell(Center(
            child: Text(
                getStoreName(context: context, storeid: product.storeid)))),
        DataCell(Text(product.created_at != null
            ? product.created_at.substring(0, 10)
            : "")),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => productList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void _sort<T>(
      Comparable<T> Function(ProductBackup d) getField, bool ascending) {
    productList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  updateAmount(ProductBackup p) {
    SizeConfig().init(context);
    String amount = '0';
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
                      value: p != null ? p.amount.toInt().toString() : null,
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
            onPressed: () {
              formKey.currentState.save();
              final i = productList.indexWhere((element) => element.id == p.id);
              if (i != -1) {
                productList[i].amount = int.parse(amount.toString().trim());
                notifyListeners();
              }

              Navigator.of(context).pop();
            },
            child: Center(
              child: Text(
                'تعديل الكمية',
                style: TextStyle(color: white, fontSize: 16),
              ),
            ),
          )
        ]).show();
  }

  filter(value) {
    if (value == "-1") {
      productList = filterproductList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<ProductBackup> l = filterproductList
          .where((element) => element.productName.contains(value))
          .toList();
      productList = l;
      notifyListeners();
      return;
    }
  }

  makeBackPer() async {
;


     showDialogWidget(context);
    final storeData = Provider.of<StoreData>(context, listen: false);
    Back b = Back(
        bill_id: permission.id,
        username: storeData.loginUser.username,
        storename: 'asd',
        products: productList
            .map((e) => BackProduct(
                product: e,
                amount: e.amount))
            .toList());
    final res = await API.addbackPermission(b);
    if (res.statusCode == 200) {
      Navigator.pop(context);
      Dialogs(context).successDilalog("تم عمل الإذن بنجاح ");
    } else {
      Navigator.pop(context);
      Dialogs(context).errorDilalog();
    } 
  }
}
