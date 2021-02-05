class Product{
num id;
String productName;
num sell_price;
num buy_price;
num amount;
num storeid;
num categoryId;
String created_at;

Product({this.id,this.created_at,this.storeid,this.amount,this.buy_price,this.productName,this.sell_price,this.categoryId});

factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      productName: json['productName'],
      sell_price: json['sell_price'],
      buy_price: json['buy_price'],
      amount: json['amount'],
      categoryId: json['categoryId'],
      storeid: json['storeid'],
      created_at: json['created_at'],
      
      );


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
    'productName':productName,
    'sell_price':sell_price,
    'buy_price':buy_price,
    'amount':amount,
    'storeid':storeid,
    'categoryId':categoryId
 
  };
 

  Map<String,dynamic> toJson()=> {
  'productName':productName,
    'sell_price':sell_price,
    'buy_price':buy_price,
    'amount':amount,
    'storeid':storeid,
    'categoryId':categoryId
  };

}