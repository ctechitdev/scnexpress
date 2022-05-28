import 'dart:convert';

import 'package:flutter/material.dart';

class callItemToHomeDetailListModel {
  final String bill_code;
  final String mtl_name;
  final String mtl_weight;
  final String mtl_size;
  final int mtl_am;
  final String mtl_total_price;
  final String create_date;
  final String ccy;
  final String cod;
  callItemToHomeDetailListModel({
    required this.bill_code,
    required this.mtl_name,
    required this.mtl_weight,
    required this.mtl_size,
    required this.mtl_am,
    required this.mtl_total_price,
    required this.create_date,
    required this.ccy,
    required this.cod,
  });

  callItemToHomeDetailListModel copyWith({
    String? bill_code,
    String? mtl_name,
    String? mtl_weight,
    String? mtl_size,
    int? mtl_am,
    String? mtl_total_price,
    String? create_date,
    String? ccy,
    String? cod,
  }) {
    return callItemToHomeDetailListModel(
      bill_code: bill_code ?? this.bill_code,
      mtl_name: mtl_name ?? this.mtl_name,
      mtl_weight: mtl_weight ?? this.mtl_weight,
      mtl_size: mtl_size ?? this.mtl_size,
      mtl_am: mtl_am ?? this.mtl_am,
      mtl_total_price: mtl_total_price ?? this.mtl_total_price,
      create_date: create_date ?? this.create_date,
      ccy: ccy ?? this.ccy,
      cod: cod ?? this.cod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bill_code': bill_code,
      'mtl_name': mtl_name,
      'mtl_weight': mtl_weight,
      'mtl_size': mtl_size,
      'mtl_am': mtl_am,
      'mtl_total_price': mtl_total_price,
      'create_date': create_date,
      'ccy': ccy,
      'cod': cod,
    };
  }

  factory callItemToHomeDetailListModel.fromMap(Map<String, dynamic> map) {
    return callItemToHomeDetailListModel(
      bill_code: map['bill_code'] ?? '',
      mtl_name: map['mtl_name'] ?? '',
      mtl_weight: map['mtl_weight'] ?? '',
      mtl_size: map['mtl_size'] ?? '',
      mtl_am: map['mtl_am']?.toInt() ?? 0,
      mtl_total_price: map['mtl_total_price'] ?? '',
      create_date: map['create_date'] ?? '',
      ccy: map['ccy'] ?? '',
      cod: map['cod'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory callItemToHomeDetailListModel.fromJson(String source) =>
      callItemToHomeDetailListModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'callItemToHomeDetailListModel(bill_code: $bill_code, mtl_name: $mtl_name, mtl_weight: $mtl_weight, mtl_size: $mtl_size, mtl_am: $mtl_am, mtl_total_price: $mtl_total_price, create_date: $create_date, ccy: $ccy, cod: $cod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is callItemToHomeDetailListModel &&
        other.bill_code == bill_code &&
        other.mtl_name == mtl_name &&
        other.mtl_weight == mtl_weight &&
        other.mtl_size == mtl_size &&
        other.mtl_am == mtl_am &&
        other.mtl_total_price == mtl_total_price &&
        other.create_date == create_date &&
        other.ccy == ccy &&
        other.cod == cod;
  }

  @override
  int get hashCode {
    return bill_code.hashCode ^
        mtl_name.hashCode ^
        mtl_weight.hashCode ^
        mtl_size.hashCode ^
        mtl_am.hashCode ^
        mtl_total_price.hashCode ^
        create_date.hashCode ^
        ccy.hashCode ^
        cod.hashCode;
  }
}
