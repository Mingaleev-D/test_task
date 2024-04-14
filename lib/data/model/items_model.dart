import 'dart:convert';

class ItemsModel {
  List<Result>? result;
  int? total;

  ItemsModel({
    this.result,
    this.total,
  });

  factory ItemsModel.fromRawJson(String str) =>
      ItemsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
        "total": total,
      };
}

class Result {
  String? id;
  String? name;
  String? description;
  String? measurementUnits;
  String? deposit;
  String? code;
  dynamic minQuantity;
  int? price;
  dynamic rentPrice;
  int? accountingPrice;
  dynamic type;
  List<dynamic>? customValues;

  Result({
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

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
