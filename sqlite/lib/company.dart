import 'package:sqlite/db.dart';

class Company {
  int id;
  String name;
  String url;
  String tel;
  String email;
  String products;
  String classification;

  Company({
    this.id,
    this.name,
    this.url,
    this.tel,
    this.email,
    this.products,
    this.classification,
  });

  Company.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.url = json[DatabaseCreator.url];
    this.tel = json[DatabaseCreator.tel];
    this.email = json[DatabaseCreator.email];
    this.products = json[DatabaseCreator.products];
    this.classification = json[DatabaseCreator.classification];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DatabaseCreator.name: name,
      DatabaseCreator.url: url,
      DatabaseCreator.tel: tel,
      DatabaseCreator.email: email,
      DatabaseCreator.products: products,
      DatabaseCreator.classification: classification,
    };
    if (id != null) {
      map[DatabaseCreator.id] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'Company: {id: $id, name: $name, url: $url, tel: $tel, email: $email, products: $products, classification: $classification}';
  }
}
