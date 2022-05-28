import 'dart:convert';

import 'package:flutter/material.dart';

class listCallItemNoAcceptModel {
  final String inv_id;
  final int inv_total;
  listCallItemNoAcceptModel({
    required this.inv_id,
    required this.inv_total,
  });

  listCallItemNoAcceptModel copyWith({
    String? inv_id,
    int? inv_total,
  }) {
    return listCallItemNoAcceptModel(
      inv_id: inv_id ?? this.inv_id,
      inv_total: inv_total ?? this.inv_total,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inv_id': inv_id,
      'inv_total': inv_total,
    };
  }

  factory listCallItemNoAcceptModel.fromMap(Map<String, dynamic> map) {
    return listCallItemNoAcceptModel(
      inv_id: map['inv_id'] ?? '',
      inv_total: map['inv_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory listCallItemNoAcceptModel.fromJson(String source) =>
      listCallItemNoAcceptModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'listCallItemNoAcceptModel(inv_id: $inv_id, inv_total: $inv_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listCallItemNoAcceptModel &&
        other.inv_id == inv_id &&
        other.inv_total == inv_total;
  }

  @override
  int get hashCode => inv_id.hashCode ^ inv_total.hashCode;
}
