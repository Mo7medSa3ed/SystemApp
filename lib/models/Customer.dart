

import 'dart:convert';

class Customer {
num id;
String name ; 
String address ; 
String phone ; 
String type ;
num total_money; 
String created_at;
List<Bill> bills;


Customer( {this.id , this.name , this.address , this.bills ,this.created_at , this.phone ,this.type ,this.total_money });


  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      type: json['type'],
      total_money: json['total_money'],
      created_at: json['created_at']
       );


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
     'name':name,
     'address':address,
     'phone':phone,
     'type':type,
  };
 

  Map<String,dynamic> toJson()=> {
     'name':name,
     'address':address,
     'phone':phone,
     'type':type,
  };



}







class Bill {

  num id ; 
  num permisionId;

  Bill({this.id, this.permisionId});


  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
      id: json['id'],
      permisionId: json['permisionId']
       );


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
    'permisionId':permisionId,
  };
 

  Map<String,dynamic> toJson()=> {
    'permisionId':permisionId,
   
  };

}