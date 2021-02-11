import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/models/Permission.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/screans/permissiondetails.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class PermissionTable extends StatefulWidget {
  @override
  _PermissionTableState createState() => _PermissionTableState();
}

class _PermissionTableState extends State<PermissionTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var cds;
  bool login = true;
  var _controller = TextEditingController();
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    final list = login
        ? storeData.permissionList
            .where((element) => element.type == 'add')
            .toList()
        : storeData.permissionList
            .where((element) => element.type == 'lack')
            .toList();
    cds =
        Cds(permissionList: list, filterPermissionList: list, context: context);
  }

  void _sort<T>(
    Comparable<T> Function(Permission d) getField,
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

  Row buildmovetabs() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: login ? Kprimary : grey,
                        width: login ? 4 : 0.7))),
            child: InkWell(
              onTap: () {
                if (login == false) {
                  setState(() {
                    login = !login;
                  });
                }
              },
              child: Text(
                'الإضافة',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700, color: Kprimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: login ? grey : Kprimary,
                          width: login ? 0.7 : 4))),
              child: InkWell(
                onTap: () {
                  if (login) {
                    setState(() {
                      login = !login;
                    });
                  }
                },
                child: Text(
                  'الصرف',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Kprimary),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            buildmovetabs(),
            Container(
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
                    label: Text('اسم العميل'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d.customer.name, columnIndex, ascending),
                  ),
                   DataColumn(
                    label: Text('المبلغ الكلى'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => (d.sum-d.paidMoney), columnIndex, ascending),
                  ),
                     DataColumn(
                    label: Text('المبلغ المدفوع'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => d.paidMoney, columnIndex, ascending),
                  ),
                     DataColumn(
                    label: Text('نوع الدفع'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d.paidType ,columnIndex, ascending),
                  ),
                    DataColumn(
                    label: Text('الخصم'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => d.discount ,columnIndex, ascending),
                  ),
                    DataColumn(
                    label: Text('اسم العامل'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d.user.username,columnIndex, ascending),
                  ),
                     DataColumn(
                    label: Text('عدد مرات التعديل'),
                    onSort: (columnIndex, ascending) => _sort<num>(
                        (d) => d.backs.length,columnIndex, ascending),
                  ),
                  DataColumn(
                    label: Text('تاريخ الاشتراك'),
                    onSort: (columnIndex, ascending) => _sort<String>(
                        (d) => d.created_at, columnIndex, ascending),
                  ),
                ],
              ),
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
  List<Permission> permissionList;
  List<Permission> filterPermissionList;
  BuildContext context;
  int _selectedCount = 0;
  Cds({this.permissionList, this.context, this.filterPermissionList});

  @override
  DataRow getRow(int index) {
    final permission = permissionList[index];
    return DataRow.byIndex(
      index: index,
      onSelectChanged: (v)=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PermisionDetailsScrean(index))),
      cells: [
        DataCell(Text(permission.id.toString())),
        DataCell(Text(permission.customer.name.toString())),
        DataCell(Center(child: Text((permission.sum-permission.paidMoney).toString()))),
        DataCell(Center(child: Text(permission.paidMoney.toString()))),
        DataCell(Text(permission.paidType)),
        DataCell(Center(child: Text(permission.discount.toString()))),
        DataCell(Text(permission.user.username)),
        DataCell(Center(child: Text(permission.backs.length.toString()+' مرة'))),
        DataCell(Text(permission.created_at != null
            ? permission.created_at.substring(0, 10)
            : "")),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => permissionList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Permission d) getField, bool ascending) {
    permissionList.sort((a, b) {
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
      permissionList = filterPermissionList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<Permission> l = filterPermissionList
          .where((element) => element.customer.name.contains(value))
          .toList();
      permissionList = l;
      notifyListeners();
      return;
    }
  }
}
