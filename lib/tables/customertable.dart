import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialogs/addcustomer.dart';
import 'package:flutter_app/models/Customer.dart';
import 'package:flutter_app/provider/specials.dart';
import 'package:flutter_app/provider/storedata.dart';
import 'package:provider/provider.dart';


class CustomerTable extends StatefulWidget {
  final String type;
  CustomerTable( {this.type} );

  @override
  _CustomerTableState createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var _sortColumnIndex = -1;
  var _sortAscending = true;
  var cds;
  var _controller = TextEditingController();
  StoreData storeData;
  getData() {
    storeData = Provider.of<StoreData>(context, listen: true);
    cds = Cds(
        type: widget.type,
        customerList: storeData.customerList,
        filtercustomerList: storeData.customerList,
        context: context);
  }

  void _sort<T>(
    Comparable<T> Function(Customer d) getField,
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
            height: 50,
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
              label: Text('له'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.hismoney, columnIndex, ascending),
            ),
             DataColumn(
              label: Text('عليه'),
              numeric: true,
              onSort: (columnIndex, ascending) =>
                  _sort<num>((d) => d.mymoney, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('العنوان'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.address, columnIndex, ascending),
            ),
            DataColumn(
              label: Text('التليفون'),
              onSort: (columnIndex, ascending) =>
                  _sort<String>((d) => d.phone, columnIndex, ascending),
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
                  contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                suffixIcon: data
                    ? Icon(Icons.search)
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          cds.filter("-1");
                          s.changeIsEmpty(true);
                        }),
                hintText: ' بحث باسم ال${widget.type} ...',
                border: InputBorder.none),
          );
        });
  }
}

class Cds extends DataTableSource {
  List<Customer> customerList;
  List<Customer> filtercustomerList;
  BuildContext context;
  String type;
  int _selectedCount = 0;
  Cds({this.customerList, this.context, this.filtercustomerList ,this.type});

  @override
  DataRow getRow(int index) {
    final customer = customerList[index];
  
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(customer.id.toString())),
        DataCell(Text(customer.name)),
        DataCell(Text(customer.hismoney.toString())),
        DataCell(Text(customer.mymoney.toString())),
        DataCell(Text(customer.address)),
        DataCell(Text(customer.phone)),
        DataCell(Text(customer.created_at != null
            ? customer.created_at.substring(0, 10)
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
                 CustomerDialog(context: context ,type:type ).addcustomer(customer: customer) ),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: red,
                ),
                onPressed: () =>
                 CustomerDialog(context: context,type:type).deletecustomer(customer)),
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
  int get rowCount => customerList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => _selectedCount;

  void _sort<T>(Comparable<T> Function(Customer d) getField, bool ascending) {
    customerList.sort((a, b) {
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
      customerList = filtercustomerList;
      notifyListeners();
      return;
    }
    if (value.toString().trim().isNotEmpty) {
      List<Customer> l = filtercustomerList
          .where((element) => element.name.contains(value))
          .toList();
      customerList = l;
      notifyListeners();
      return;
    }
  }
}
