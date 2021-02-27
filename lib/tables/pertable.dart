import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addproduct.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';

class PerTable extends StatefulWidget {
  final type;
  PerTable({this.type});
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<PerTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var pds;
  var _controller = TextEditingController();

  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    final list = storeData.productTableList;
    pds = PDS(
        context: context,
        productList: list,
        filterproductList: list,
        type: widget.type);
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
          header: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: greyw, borderRadius: BorderRadius.circular(10)),
                  child: buildTextField(),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    size: 35,
                    color: red,
                  ),
                  onPressed: () {
                    final l = storeData.productTableList
                        .where((element) => element.selected)
                        .toList();
                    if (l.length > 0) {
                      ProductDialog(context: context).deleteProductsTable(l);
                    } else {
                      Dialogs(context).warningDilalog2(
                          msg: '!! برجاء اختيار منتج ع الأقل ');
                    }
                  }),
            ],
          ),
          sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
          sortAscending: _sortAscending,
          showCheckboxColumn: true,
          onSelectAll: pds._selectAll,
          source: pds,
          columns: [
            DataColumn(
              label: Text('Id'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.id, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('اسم المنتج'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.productName, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('الفئة'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.categoryId, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الكمية'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.amount, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text(widget.type == 'add' ? 'سعر الشراء' : 'سعر البيع'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.sell_price, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('الخصم'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.discount, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('المخزن'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getStoreName(context: context, storeid: d.storeid),
                  columnIndex,
                  ascending),
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
              
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  String type;
  int _selectedCount = 0;
  StoreData _storeData;
  PDS({this.productList, this.context, this.filterproductList, this.type});

  @override
  DataRow getRow(int index) {
    final product = productList[index];
    return DataRow.byIndex(
      selected: product.selected,
      onSelectChanged: (value) {
        if (product.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          product.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(product.id.toString())),
        DataCell(Text(product.productName)),
        DataCell(
            Text(getCategoryname(context: context, id: product.categoryId))),
        DataCell(Center(child: Text(product.amount.toString())),
            showEditIcon: true,
            onTap: () => ProductDialog(context: context)
                .updateAmount(product, type, false)),
        DataCell(Center(
            child: Text(type == 'add'
                ? product.buy_price.toString()
                : product.sell_price.toString()))),
        DataCell(Center(child: Text(product.discount.toString())),
            showEditIcon: true,
            onTap: () => ProductDialog(context: context)
                .updateAmount(product, type, true)),
        DataCell(
            Text(getStoreName(context: context, storeid: product.storeid))),
        DataCell(Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () => ProductDialog(context: context)
                    .deleteProductfrontable(product))
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
  int get selectedRowCount => 0;

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

  void _selectAll(bool checked) {
    int c = 0;
    for (Product user in productList) {
      user.selected = !user.selected;
      if (user.selected) {
        c++;
      }
    }

    _selectedCount = checked ? c : 0;
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

/**
 * productList.where((element) {
        return [].contains(element);
      });
 * 
 */
