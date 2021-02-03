class Store{
num id;
String storename;
String address;
num manager;
String created_at;

Store({this.address,this.manager,this.created_at,this.id,this.storename});

factory Store.fromJson(Map<String, dynamic> json) => Store(
      id: json['id'],
      storename: json['storename'],
      address: json['address'],
      created_at: json['created_at'],
      manager: json['manager']);


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
    'storename':storename,
    'manager':manager,
    'address':address,
  };
 

  Map<String,dynamic> toJson()=> {
    'storename':storename,
    'address':address,
    'manager':manager,
   
  };

}