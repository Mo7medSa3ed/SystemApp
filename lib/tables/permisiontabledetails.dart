import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class PermisionTableDetails extends StatefulWidget {
  List<ProductBackup> list;
  String type;
  PermisionTableDetails(this.list, this.type);
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<PermisionTableDetails> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var pds;
  var _controller = TextEditingController();

  getData() {
    pds = PDS(
        context: context,
        productList: widget.list,
        filterproductList: widget.list);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void _sort<T>(
    Comparable<T> Function(ProductBackup d) getField,
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: greyw, borderRadius: BorderRadius.circular(10)),
                  child: buildTextField(),
                ),
              ),
            ],
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
              label: Text('اسم المنتج'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.productName, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الفئة'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.categoryId.toString(), columnIndex, ascending),
            ),
            DataColumn(
              label: Text(
                  widget.type != 'add' ? 'الكمية المصروفة' : 'الكمية المضافة'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.amount, columnIndex, ascending),
            ),
            DataColumn(
              label: Text(widget.type != 'add'
                  ? 'الكمية قبل الصرف'
                  : 'الكمية قبل الإضافة'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.amount_before, columnIndex, ascending),
            ),
            DataColumn(
              label: Text(widget.type != 'add'
                  ? 'الكمية بعد الصرف'
                  : 'الكمية بعد الإضافة'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.amount_after, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('الخصم'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.discount, columnIndex, ascending),
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
  List<ProductBackup> productList;
  List<ProductBackup> filterproductList;
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
        DataCell(
            Text(getCategoryname(context: context, id: product.categoryId))),
        DataCell(Center(child: Text(product.amount.toString()))),
        DataCell(Center(child: Text(product.amount_before.toString()))),
        DataCell(Center(child: Text(product.amount_after.toString()))),
        DataCell(Center(child: Text(product.discount.toString()))),
        DataCell(Center(child: Text(product.buy_price.toString()))),
        DataCell(Center(child: Text(product.sell_price.toString()))),
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
}

/**
 * productList.where((element) {
        return [].contains(element);
      });
 * 
 */
