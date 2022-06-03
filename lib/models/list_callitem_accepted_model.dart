import 'dart:convert';

import 'package:flutter/material.dart';

class listCallItemAcceptedModel {
  final String inv_id;
  final int inv_total;
  listCallItemAcceptedModel({
    required this.inv_id,
    required this.inv_total,
  });

  listCallItemAcceptedModel copyWith({
    String? inv_id,
    int? inv_total,
  }) {
    return listCallItemAcceptedModel(
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

  factory listCallItemAcceptedModel.fromMap(Map<String, dynamic> map) {
    return listCallItemAcceptedModel(
      inv_id: map['inv_id'] ?? '',
      inv_total: map['inv_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory listCallItemAcceptedModel.fromJson(String source) =>
      listCallItemAcceptedModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'listCallItemAcceptedModel(inv_id: $inv_id, inv_total: $inv_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listCallItemAcceptedModel &&
        other.inv_id == inv_id &&
        other.inv_total == inv_total;
  }

  @override
  int get hashCode => inv_id.hashCode ^ inv_total.hashCode;
}
