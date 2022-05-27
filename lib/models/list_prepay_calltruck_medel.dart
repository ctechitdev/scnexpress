import 'dart:convert';

import 'package:flutter/material.dart';

class listPrepayCallTruckModel {
  final String bill_header;

  final int bill_total;
  listPrepayCallTruckModel({
    required this.bill_header,
    required this.bill_total,
  });

  listPrepayCallTruckModel copyWith({
    String? bill_header,
    int? bill_total,
  }) {
    return listPrepayCallTruckModel(
      bill_header: bill_header ?? this.bill_header,
      bill_total: bill_total ?? this.bill_total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bill_header': bill_header,
      'bill_total': bill_total,
    };
  }

  factory listPrepayCallTruckModel.fromMap(Map<String, dynamic> map) {
    return listPrepayCallTruckModel(
      bill_header: map['bill_header'] ?? '',
      bill_total: map['bill_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory listPrepayCallTruckModel.fromJson(String source) =>
      listPrepayCallTruckModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'listPrepayCallTruckModel(bill_header: $bill_header, bill_total: $bill_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listPrepayCallTruckModel &&
        other.bill_header == bill_header &&
        other.bill_total == bill_total;
  }

  @override
  int get hashCode => bill_header.hashCode ^ bill_total.hashCode;
}
