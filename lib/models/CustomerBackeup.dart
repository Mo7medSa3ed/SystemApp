class CustomerBackeup {
  num id;
  num customerId;
  String name;
  String address;
  String phone;
  String type;
  String created_at;

  CustomerBackeup(
      {this.id,
      this.name,
      this.address,
      this.customerId,
      this.created_at,
      this.phone,
      this.type});

  factory CustomerBackeup.fromJson(Map<String, dynamic> json) =>
      CustomerBackeup(
          id: json['id'],
          customerId: json['customerId'],
          name: json['name'],
          address: json['address'],
          phone: json['phone'],
          type: json['type'],
          created_at: json['created_at']);

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'customerId': customerId,
        'name': name,
        'address': address,
        'phone': phone,
        'type': type,
      };

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'name': name,
        'address': address,
        'phone': phone,
        'type': type,
      };
}
