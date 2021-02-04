import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/adduser.dart';
import 'package:flutter_app/dialogs/dialogs.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:flutter_app/size_config.dart';
import 'package:provider/provider.dart';

class UsersTable extends StatefulWidget {
  @override
  _UsersTableState createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var uds;
  var _controller = TextEditingController();
  List<User> userList=[];
  StoreData storeData;
  Specials s;

  getData()  {
    storeData = Provider.of<StoreData>(context,listen: true);
    userList =storeData.userList;
    final list =
        userList.where((element) => element.id != storeData.loginUser.id).toList();
    uds = UDS(userList: list, filteruserList: list, context: context);
  }


  void _sort<T>(
    Comparable<T> Function(User d) getField,
    int columnIndex,
    bool ascending,
  ) {
    uds._sort<T>(getField, ascending);
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
          onSelectAll: uds._selectAll,
          showCheckboxColumn:true,
          source: uds,
          columns: [
            DataColumn(
              label: Text('id'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.id.toString(), columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الاسم'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.username, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('الوظيفة'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.role, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('المخزن'),
              onSort: (columnIndex, ascending) => _sort<String>(
                  (d) => getStoreName(context: context, storeid: d.storeid),
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
     s = Provider.of<Specials>(context,listen: false); 
    return Selector<Specials, bool>(
        selector: (_, m) => m.istextempty,
        builder: (_, data, c) {
          return TextField(
            controller: _controller,
            onChanged: (v) {
              if (v.toString().trim() == "") {
                uds.filter("-1");
                s.changeIsEmpty(true);
                          _controller.clear();

              } else {
                uds.filter(v.trim());
                s.changeIsEmpty(false);
              }
            },
            cursorColor: Kprimary,
            decoration: InputDecoration(
                suffixIcon: _controller.text.toString().trim()==""
                    ? Icon(Icons.search)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          uds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: 'بحث باسم العامل ...',
                border: InputBorder.none),
          );
        });
  }
}

class UDS extends DataTableSource {
  List<User> userList;
  List<User> filteruserList;
  BuildContext context;
  int _selectedCount = 0;
  UDS({this.userList, this.context, this.filteruserList});

  @override
  DataRow getRow(int index) {
    final user = userList[index];
    return DataRow.byIndex(
      index: index,
      selected: user.selected,
      onSelectChanged: (value) {
        if (user.role != "مدير مخزن") {
          if (user.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            user.selected = value;
            notifyListeners();
          }
        }else{
          Dialogs(context).warningDilalog2(msg: '!! لا يمكن اختيار مدير مخزن');
          return;
        }
      },
      cells: [
        DataCell(Text(user.id.toString())),
        DataCell(Text(user.username)),
        DataCell(Text(user.role)),
        DataCell(Text(getStoreName(context: context, storeid: user.storeid))),
        DataCell(Text(
            user.created_at != null ? user.created_at.substring(0, 10) : "")),
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
                    Usersdialog(context: context).addUser(user: user)),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () =>
                    Usersdialog(context: context).deleteUser(user)),
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
  int get rowCount => userList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool checked) {
    int c=0;
    for (User user in userList) {
      if (user.role != "مدير مخزن") {
        user.selected = !user.selected;
        if(user.selected){c++;}
      }
    }
    
    _selectedCount = checked ? c : 0;
    notifyListeners();
  }

  void _sort<T>(Comparable<T> Function(User d) getField, bool ascending) {
    userList.sort((a, b) {
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
      userList = filteruserList;
      notifyListeners();
      return false;
    }
    final l =
        userList.where((element) => element.username.contains(value)).toList();
    userList = l;
    notifyListeners();
    return true;
  }

  showSheckable(v){
    StoreData storeData = Provider.of<StoreData>(context, listen: false);
    storeData.changeCheckable(v);
  }


}
