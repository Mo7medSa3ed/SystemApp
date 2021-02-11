import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addproduct.dart';
import 'package:flutter_app/models/category.dart';
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
  List<Product> filterdata = [];
  List<String> filterList=[];
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    pds = PDS(
        context: context,
        productList: storeData.productList,
        filterproductList: storeData.productList);
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



void _openFilterDialog() async {
    await FilterListDialog.display(
      context,
      allTextList: storeData.categoryList.map((e) => e.name).toList(),
      height: 480,
      borderRadius: 20,
      headlineText: "Select Categories",
      searchFieldHintText: "Search here",
      selectedTextList: filterList,
      headerTextColor: Kprimary,
      applyButonTextBackgroundColor:Kprimary,
      allResetButonColor:Kprimary,
      selectedTextBackgroundColor:Kprimary,
      onApplyButtonClick: (list) {
        if (list != null) {
          setState(() {
            filterList = List.from(list);
          });
        }
        Navigator.pop(context);
      });
  }



  categoryfilter(List<String> list){
      List<num> idList=[];
      list.forEach((element) {
        idList.add( storeData.categoryList.firstWhere((e) =>e.name==element).id);
      });

      filterdata=storeData.productList.where((element) => idList.contains(element.categoryId)).toList();
      print(filterdata.length);
        pds = PDS(
        context: context,
        productList: filterdata,
        filterproductList: storeData.productList);
  }
    




  @override
  Widget build(BuildContext context) {
    filterList.length>0? categoryfilter(filterList):getData();
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
                  height: getProportionateScreenHeight(55),
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
                    Icons.filter_list_alt,
                    size: 35,
                    color: Kprimary,
                  ),
                  onPressed: ()async =>await _openFilterDialog()),
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
                  (d) =>getCategoryname(context: context,id:  d.categoryId), columnIndex, ascending),
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
  StoreData _storeData ;
  PDS({this.productList, this.context, this.filterproductList});

  @override
  DataRow getRow(int index) {
    final product = productList[index];
    return DataRow.byIndex(
      index: index,
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
        DataCell(Center(child: Text(product.buy_price.toString()))),
        DataCell(Center(child: Text(product.sell_price.toString()))),
        DataCell(Center(child: Text(product.amount.toString()))),
        DataCell(
            Text(getStoreName(context: context, storeid: product.storeid))),
        DataCell(
            Text(getCategoryname(context: context, id: product.categoryId))),
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
                onPressed: () =>
                    ProductDialog(context: context).addproduct(p: product)),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () =>
                    ProductDialog(context: context).deleteproduct(product))
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