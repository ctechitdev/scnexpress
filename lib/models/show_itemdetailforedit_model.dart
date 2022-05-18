import 'dart:convert';

class ShowItemDetailForEditModel {
  final String bill_code;
  final String bill_header;
  final String mtl_name;
  final String mtl_type;
  final String mtl_weight;
  final String mtl_size;
  final int mtl_am;
  final String mtl_total_price;
  final String create_date;
  final String ccy;
  final int express_price;
  final int cod_price;
  final String cod;
  final int vehicle_price;
  ShowItemDetailForEditModel({
    required this.bill_code,
    required this.bill_header,
    required this.mtl_name,
    required this.mtl_type,
    required this.mtl_weight,
    required this.mtl_size,
    required this.mtl_am,
    required this.mtl_total_price,
    required this.create_date,
    required this.ccy,
    required this.express_price,
    required this.cod_price,
    required this.cod,
    required this.vehicle_price,
  });

  ShowItemDetailForEditModel copyWith({
    String? bill_code,
    String? bill_header,
    String? mtl_name,
    String? mtl_type,
    String? mtl_weight,
    String? mtl_size,
    int? mtl_am,
    String? mtl_total_price,
    String? create_date,
    String? ccy,
    int? express_price,
    int? cod_price,
    String? cod,
    int? vehicle_price,
  }) {
    return ShowItemDetailForEditModel(
      bill_code: bill_code ?? this.bill_code,
      bill_header: bill_header ?? this.bill_header,
      mtl_name: mtl_name ?? this.mtl_name,
      mtl_type: mtl_type ?? this.mtl_type,
      mtl_weight: mtl_weight ?? this.mtl_weight,
      mtl_size: mtl_size ?? this.mtl_size,
      mtl_am: mtl_am ?? this.mtl_am,
      mtl_total_price: mtl_total_price ?? this.mtl_total_price,
      create_date: create_date ?? this.create_date,
      ccy: ccy ?? this.ccy,
      express_price: express_price ?? this.express_price,
      cod_price: cod_price ?? this.cod_price,
      cod: cod ?? this.cod,
      vehicle_price: vehicle_price ?? this.vehicle_price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bill_code': bill_code,
      'bill_header': bill_header,
      'mtl_name': mtl_name,
      'mtl_type': mtl_type,
      'mtl_weight': mtl_weight,
      'mtl_size': mtl_size,
      'mtl_am': mtl_am,
      'mtl_total_price': mtl_total_price,
      'create_date': create_date,
      'ccy': ccy,
      'express_price': express_price,
      'cod_price': cod_price,
      'cod': cod,
      'vehicle_price': vehicle_price,
    };
  }

  factory ShowItemDetailForEditModel.fromMap(Map<String, dynamic> map) {
    return ShowItemDetailForEditModel(
      bill_code: map['bill_code'] ?? '',
      bill_header: map['bill_header'] ?? '',
      mtl_name: map['mtl_name'] ?? '',
      mtl_type: map['mtl_type'] ?? '',
      mtl_weight: map['mtl_weight'] ?? '',
      mtl_size: map['mtl_size'] ?? '',
      mtl_am: map['mtl_am']?.toInt() ?? 0,
      mtl_total_price: map['mtl_total_price'] ?? '',
      create_date: map['create_date'] ?? '',
      ccy: map['ccy'] ?? '',
      express_price: map['express_price']?.toInt() ?? 0,
      cod_price: map['cod_price']?.toInt() ?? 0,
      cod: map['cod'] ?? '',
      vehicle_price: map['vehicle_price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShowItemDetailForEditModel.fromJson(String source) =>
      ShowItemDetailForEditModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShowItemDetailForEditModel(bill_code: $bill_code, bill_header: $bill_header, mtl_name: $mtl_name, mtl_type: $mtl_type, mtl_weight: $mtl_weight, mtl_size: $mtl_size, mtl_am: $mtl_am, mtl_total_price: $mtl_total_price, create_date: $create_date, ccy: $ccy, express_price: $express_price, cod_price: $cod_price, cod: $cod, vehicle_price: $vehicle_price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShowItemDetailForEditModel &&
        other.bill_code == bill_code &&
        other.bill_header == bill_header &&
        other.mtl_name == mtl_name &&
        other.mtl_type == mtl_type &&
        other.mtl_weight == mtl_weight &&
        other.mtl_size == mtl_size &&
        other.mtl_am == mtl_am &&
        other.mtl_total_price == mtl_total_price &&
        other.create_date == create_date &&
        other.ccy == ccy &&
        other.express_price == express_price &&
        other.cod_price == cod_price &&
        other.cod == cod &&
        other.vehicle_price == vehicle_price;
  }

  @override
  int get hashCode {
    return bill_code.hashCode ^
        bill_header.hashCode ^
        mtl_name.hashCode ^
        mtl_type.hashCode ^
        mtl_weight.hashCode ^
        mtl_size.hashCode ^
        mtl_am.hashCode ^
        mtl_total_price.hashCode ^
        create_date.hashCode ^
        ccy.hashCode ^
        express_price.hashCode ^
        cod_price.hashCode ^
        cod.hashCode ^
        vehicle_price.hashCode;
  }
}
