import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addstore.dart';
import 'package:flutter_app/models/store.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class StoreTable extends StatefulWidget {
  @override
  _StoreTableState createState() => _StoreTableState();
}

class _StoreTableState extends State<StoreTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var sds;
  var _controller = TextEditingController();
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context,listen: true);
    sds = SDS(storeList:storeData.storeList, filterstoreList: storeData.storeList, context: context);
  }
 

  void _sort<T>(
    Comparable<T> Function(Store d) getField,
    int columnIndex,
    bool ascending,
  ) {
    sds._sort<T>(getField, ascending);
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
          source: sds,
          columns: [
            DataColumn(
              label: Text('Id'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.id.toString(), columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الاسم'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.storename, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('العنوان'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.address, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('المدير'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getUsername(context: context, userid: d.manager),
                  columnIndex,
                  ascending),
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
    Specials s =Provider.of<Specials>(context,listen: false);
    return Selector<Specials, bool>(
        selector: (_, m) => m.istextempty,
        builder: (_, data, c) {
      
    return TextField(
      controller: _controller,
      onChanged: (v) {
        if (v.trim() == "") {
          sds.filter("-1");
          s.changeIsEmpty(true);
          _controller.clear();
        } else {
          sds.filter(v.trim());
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
                    sds.filter("-1");
                    s.changeIsEmpty(true);
                  }),
          hintText: 'بحث باسم المخزن ...',
          border: InputBorder.none),
    );
      });
  }
}

class SDS extends DataTableSource {
  List<Store> storeList;
  List<Store> filterstoreList;
  BuildContext context;
  int _selectedCount = 0;
  SDS({this.storeList, this.context, this.filterstoreList});

  @override
  DataRow getRow(int index) {
    final store = storeList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(store.id.toString())),
        DataCell(Text(store.storename)),
        DataCell(Text(store.address)),
        DataCell(Text(getUsername(context: context, userid: store.manager))),
        DataCell(Text(
            store.created_at != null ? store.created_at.substring(0, 10) : "")),
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
                    Storesdialog(context: context).addstore(store: store)),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () =>
                    Storesdialog(context: context).deletestore(store)),
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
  int get rowCount => storeList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Store d) getField, bool ascending) {
    storeList.sort((a, b) {
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
      storeList = filterstoreList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {    
    List<Store> l = filterstoreList
        .where((element) => element.storename.contains(value))
        .toList();
    storeList = l;
    notifyListeners();
    return;
  }}
}
