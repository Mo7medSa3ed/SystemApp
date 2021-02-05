import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcategory.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';


class CategoryTable extends StatefulWidget {
  @override
  _CategoryTableState createState() => _CategoryTableState();
}

class _CategoryTableState extends State<CategoryTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var cds;
  var _controller = TextEditingController();
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    cds = Cds(
        categoryList: storeData.categoryList,
        filterCategoryList: storeData.categoryList,
        context: context);
  }

  void _sort<T>(
    Comparable<T> Function(Categorys d) getField,
    int columnIndex,
    bool ascending,
  ) {
    cds._sort<T>(getField, ascending);
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
          source: cds,
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
                  _sort<String>((d) => d.name, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('عدد المنتجات بداخلها'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.productslength, columnIndex, ascending),
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
                cds.filter("-1");
                s.changeIsEmpty(true);
                _controller.clear();
              } else {
                cds.filter(v.trim());
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
                          cds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: 'بحث باسم الفئة ...',
                border: InputBorder.none),
          );
        });
  }
}

class Cds extends DataTableSource {
  List<Categorys> categoryList;
  List<Categorys> filterCategoryList;
  BuildContext context;
  int _selectedCount = 0;
  Cds({this.categoryList, this.context, this.filterCategoryList});

  @override
  DataRow getRow(int index) {
    final category = categoryList[index];
    print(category.productslength);
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(category.id.toString())),
        DataCell(Text(category.name)),
        DataCell(Center(child: Text(category.productslength.toString()))),
        DataCell(Text(category.created_at != null
            ? category.created_at.substring(0, 10)
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
                 CategoryDialog(context: context).addcategory(category: category) ),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () =>
                 CategoryDialog(context: context).deletecategory(category)),
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
  int get rowCount => categoryList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Categorys d) getField, bool ascending) {
    categoryList.sort((a, b) {
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
      categoryList = filterCategoryList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<Categorys> l = filterCategoryList
          .where((element) => element.name.contains(value))
          .toList();
      categoryList = l;
      notifyListeners();
      return;
    }
  }
}
