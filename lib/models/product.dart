import 'dart:convert';

class Product {
  String? id;
  String name;
  String? picture;
  int? price;
  int? stock;
  bool? available;

  Product(
      {this.id,
      required this.name,
      this.picture,
      this.price = 0,
      this.stock = 0,
      this.available = false});

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        name: json["name"],
        picture: json["picture"],
        price: json["price"],
        stock: json["stock"],
        available: json["available"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "picture": picture,
        "price": price,
        "stock": stock,
        "available": available,
      };

  Product copy() => Product(
        id: this.id,
        name: this.name,
        available: this.available,
        price: this.price,
        picture: this.picture,
        stock: this.stock,
      );
}
