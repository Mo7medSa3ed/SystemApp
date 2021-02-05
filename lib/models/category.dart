

class Categorys {
num id;
String name;
num productslength;
String created_at;

Categorys({this.productslength,this.created_at,this.id,this.name});

factory Categorys.fromJson(Map<String, dynamic> json) => Categorys(
      id: json['id'],
      name: json['name'],
      productslength: json['productslength'],
      created_at: json['created_at'] );


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
    'name':name,
    'productslength':productslength,
  };
 

  Map<String,dynamic> toJson()=> {
    'name':name,
    'productslength':productslength,
   
  };

}