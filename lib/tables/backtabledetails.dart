import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class BackTableDetails extends StatefulWidget {
  List<BackProduct> list;
  BackTableDetails(this.list);
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<BackTableDetails> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var pds;
  var _controller = TextEditingController();

  StoreData storeData;
  getData() {
    pds = PDS(
        context: context,
        backProductList: widget.list,
        filterBackProductList: widget.list);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: getProportionateScreenHeight(55),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: greyw, borderRadius: BorderRadius.circular(10)),
            child: buildTextField(),
          ),
          sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
          sortAscending: _sortAscending,
          source: pds,
          columns: [
            DataColumn(
              label: Text('Id'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.product.id, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الاسم'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.product.productName, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('سعر الشراء'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.product.buy_price, columnIndex, ascending),
            ),
            DataColumn(
              numeric: true,
              label: Text('سعر البيع '),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.product.sell_price, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الكمية'),
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.product.amount, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('المخزن'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getStoreName(context: context, storeid: d.product.storeid),
                  columnIndex,
                  ascending),
            ),
            DataColumn(
              label: Text('الفئة'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getCategoryname(context: context,id:  d.product.categoryId), columnIndex, ascending),
            ),
            DataColumn(
              label: Text('تاريخ الاشتراك'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.product.created_at, columnIndex, ascending),
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
  List<BackProduct> backProductList;
  List<BackProduct> filterBackProductList;
  BuildContext context;
  int _selectedCount = 0;
  StoreData _storeData ;
  PDS({this.backProductList, this.context, this.filterBackProductList});

  @override
  DataRow getRow(int index) {
    final backProduct = backProductList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(backProduct.product.id.toString())),
        DataCell(Text(backProduct.product.productName)),
        DataCell(Center(child: Text(backProduct.product.buy_price.toString()))),
        DataCell(Center(child: Text(backProduct.product.sell_price.toString()))),
        DataCell(Center(child: Text(backProduct.product.amount.toString()))),
        DataCell(
            Text(getStoreName(context: context, storeid: backProduct.product.storeid))),
        DataCell(
            Text(getCategoryname(context: context, id: backProduct.product.categoryId))),
        DataCell(Text(backProduct.product.created_at != null
            ? backProduct.product.created_at.substring(0, 10)
            : "")),
        
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => backProductList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(BackProduct d) getField, bool ascending) {
    backProductList.sort((a, b) {
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
      backProductList = filterBackProductList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<BackProduct> l = filterBackProductList
          .where((element) => element.product.productName.contains(value))
          .toList();
      backProductList = l;
      notifyListeners();
      return;
    }

   

  }
}


/**
 * BackProductList.where((element) {
        return [].contains(element);
      });
 * 
 */