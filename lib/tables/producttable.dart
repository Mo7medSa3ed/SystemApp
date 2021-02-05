import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class ProductTable extends StatefulWidget {
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<ProductTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var pds;
  var _controller = TextEditingController();
  List<Product> f =[];
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    pds = PDS(context: context,productList: storeData.productList,filterproductList: storeData.productList);
  }

  void _sort<T>(
    Comparable<T> Function(Product d) getField,
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
    getData();
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: PaginatedDataTable(
          rowsPerPage: _rowsPerPage,
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          header: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: getProportionateScreenHeight(40),
            width: double.infinity,
            decoration: BoxDecoration(
                color: greyw, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: buildTextField(),
            ),
          ),
          sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
          sortAscending: _sortAscending,
          showCheckboxColumn: false,
          source: pds,
          columns: [
            DataColumn(
              label: Text('Id'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.id, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الاسم'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.productName, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('سعر الشراء'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.buy_price, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('سعر البيع '),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.sell_price, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الكمية'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.amount, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('المخزن'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getStoreName(context: context, storeid: d.storeid),
                  columnIndex,
                  ascending),
            ),
            DataColumn(
              label: Text('الفئة'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.categoryId.toString(), columnIndex, ascending),
            ),
            DataColumn(
              label: Text('تاريخ الاشتراك'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.created_at, columnIndex, ascending),
            ),
            DataColumn(
              label: Expanded(child: Center(child: Text('تعديل / حذف'))),
            ),
          ],
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
  List<Product> productList;
  List<Product> filterproductList;
  BuildContext context;
  int _selectedCount = 0;
  PDS({this.productList, this.context, this.filterproductList});

  @override
  DataRow getRow(int index) {
    final product = productList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(product.id.toString())),
        DataCell(Text(product.productName)),
        DataCell(Text(product.buy_price.toString())),
        DataCell(Text(product.sell_price.toString())),
        DataCell(Text(product.amount.toString())),
        DataCell(
            Text(getStoreName(context: context, storeid: product.storeid))),
        DataCell(Text(product.categoryId.toString())),
        DataCell(Text(product.created_at != null
            ? product.created_at.substring(0, 10)
            : "")),
        DataCell(Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: black,
                ),
                onPressed: () {}),
            // Storesdialog(context: context).addstore(product: Product)),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () {})
            // Storesdialog(context: context).deletestore(Product)),
          ],
        ))),
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
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Product d) getField, bool ascending) {
    productList.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  filter(value) {
    if (value == "-1") {
      productList = filterproductList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<Product> l = filterproductList
          .where((element) => element.productName.contains(value))
          .toList();
      productList = l;
      notifyListeners();
      return;
    }
  }
}
