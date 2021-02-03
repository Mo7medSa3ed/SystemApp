
class User {
  num id;
  String username;
  String password;
  String role;
  num storeid;
  String created_at;
  bool selected=false;

  User(
      {this.id,
      this.created_at,
      this.password,
      this.role,
      this.storeid,
      this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      created_at: json['created_at'],
      storeid: json['storeid']);


  Map<String,dynamic> toJsonForUpdate()=> {
    'id':id,
    'username':username,
    'password':password,
    'role':role,
    'storeid':storeid
  };
 

  Map<String,dynamic> toJson()=> {
    'username':username,
    'password':password,
    'role':role,
    'storeid':storeid
  };

}


