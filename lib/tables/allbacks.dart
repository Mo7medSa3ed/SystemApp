import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Back.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/backdetailsScrean.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class AllBacksTable extends StatefulWidget {
  @override
  _BackTableState createState() => _BackTableState();
}

class _BackTableState extends State<AllBacksTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var cds;
  bool login = true;
  var _controller = TextEditingController();
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    final list =storeData.backs;
    cds =
        Cds(BackList: list, filterBackList: list, context: context);
  }

  void _sort<T>(
    Comparable<T> Function(Back d) getField,
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: getProportionateScreenHeight(55),
            width: double.infinity,
            decoration: BoxDecoration(
                color: greyw, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: buildTextField(),
            ),
          ),
          sortColumnIndex:
              _sortColumnIndex == -1 ? null : _sortColumnIndex,
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
              label: Text('رقم الفاتورة'),
              onSort: (columnIndex, ascending) => _sort<num>(
                  (d) => d.bill_id, columnIndex, ascending),
            ),
             DataColumn(
              label: Text('اسم المخزن'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.storename, columnIndex, ascending),
            ),
               DataColumn(
              label: Text('اسم العامل'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.username, columnIndex, ascending),
            ),
             DataColumn(
              label: Text('اسم العميل'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.customer.name,columnIndex, ascending),
            ),
               DataColumn(
              label: Text('عدد المنتجات المرتجعة'),
              onSort: (columnIndex, ascending) => _sort<num>(
                  (d) => d.products.length ,columnIndex, ascending),
            ),
             
            DataColumn(
              label: Text('تاريخ الاشتراك'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => d.created_at, columnIndex, ascending),
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
                hintText: 'بحث باسم العميل ...',
                border: InputBorder.none),
          );
        });
  }
}

class Cds extends DataTableSource {
  List<Back> BackList;
  List<Back> filterBackList;
  BuildContext context;
  int _selectedCount = 0;
  Cds({this.BackList, this.context, this.filterBackList});

  @override
  DataRow getRow(int index) {
    final back = BackList[index];
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (v)=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BackdetailsScrean(back))),
    
      cells: [
        DataCell(Text(back.id.toString())),
        DataCell(Text(back.bill_id.toString())),
        DataCell(Center(child: Text(back.storename))),
        DataCell(Center(child: Text(back.username))),
        DataCell(Text(back.customer.name)),
        DataCell(Text(back.products.length.toString())),
        DataCell(Text(back.created_at != null
            ? back.created_at.substring(0, 10)
            : "")),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => BackList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Back d) getField, bool ascending) {
    BackList.sort((a, b) {
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
      BackList = filterBackList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<Back> l = filterBackList
          .where((element) => element.customer.name.contains(value))
          .toList();
      BackList = l;
      notifyListeners();
      return;
    }
  }
}
