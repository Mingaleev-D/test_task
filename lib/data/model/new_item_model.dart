import 'dart:convert';

class NewItemModel {
  String? id;
  String? name;
  dynamic description;
  String? measurementUnits;
  dynamic deposit;
  dynamic code;
  dynamic minQuantity;
  dynamic price;
  dynamic rentPrice;
  dynamic accountingPrice;
  dynamic type;
  List<dynamic>? customValues;

  NewItemModel({
    this.id,
    this.name,
    this.description,
    this.measurementUnits,
    this.deposit,
    this.code,
    this.minQuantity,
    this.price,
    this.rentPrice,
    this.accountingPrice,
    this.type,
    this.customValues,
  });

  factory NewItemModel.fromRawJson(String str) =>
      NewItemModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewItemModel.fromJson(Map<String, dynamic> json) => NewItemModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        measurementUnits: json["measurement_units"],
        deposit: json["deposit"],
        code: json["code"],
        minQuantity: json["min_quantity"],
        price: json["price"],
        rentPrice: json["rent_price"],
        accountingPrice: json["accounting_price"],
        type: json["type"],
        customValues: json["custom_values"] == null
            ? []
            : List<dynamic>.from(json["custom_values"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "measurement_units": measurementUnits,
        "deposit": deposit,
        "code": code,
        "min_quantity": minQuantity,
        "price": price,
        "rent_price": rentPrice,
        "accounting_price": accountingPrice,
        "type": type,
        "custom_values": customValues == null
            ? []
            : List<dynamic>.from(customValues!.map((x) => x)),
      };
}
