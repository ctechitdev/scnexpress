// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class billListSelectPrint {
  final String inv_id;
  final int inv_total;
  final String inv_date;
  final String inv_time;
  final String bill_type;
  billListSelectPrint({
    required this.inv_id,
    required this.inv_total,
    required this.inv_date,
    required this.inv_time,
    required this.bill_type,
  });

  billListSelectPrint copyWith({
    String? inv_id,
    int? inv_total,
    String? inv_date,
    String? inv_time,
    String? bill_type,
  }) {
    return billListSelectPrint(
      inv_id: inv_id ?? this.inv_id,
      inv_total: inv_total ?? this.inv_total,
      inv_date: inv_date ?? this.inv_date,
      inv_time: inv_time ?? this.inv_time,
      bill_type: bill_type ?? this.bill_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inv_id': inv_id,
      'inv_total': inv_total,
      'inv_date': inv_date,
      'inv_time': inv_time,
      'bill_type': bill_type,
    };
  }

  factory billListSelectPrint.fromMap(Map<String, dynamic> map) {
    return billListSelectPrint(
      inv_id: map['inv_id'] as String,
      inv_total: map['inv_total'] as int,
      inv_date: map['inv_date'] as String,
      inv_time: map['inv_time'] as String,
      bill_type: map['bill_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory billListSelectPrint.fromJson(String source) =>
      billListSelectPrint.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'billListSelectPrint(inv_id: $inv_id, inv_total: $inv_total, inv_date: $inv_date, inv_time: $inv_time, bill_type: $bill_type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is billListSelectPrint &&
        other.inv_id == inv_id &&
        other.inv_total == inv_total &&
        other.inv_date == inv_date &&
        other.inv_time == inv_time &&
        other.bill_type == bill_type;
  }

  @override
  int get hashCode {
    return inv_id.hashCode ^
        inv_total.hashCode ^
        inv_date.hashCode ^
        inv_time.hashCode ^
        bill_type.hashCode;
  }
}
