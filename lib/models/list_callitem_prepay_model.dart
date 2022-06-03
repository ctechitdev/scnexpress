import 'dart:convert';

import 'package:flutter/material.dart';

class listCallItemPrepayModel {
  final String inv_id;
  final int inv_total;
  listCallItemPrepayModel({
    required this.inv_id,
    required this.inv_total,
  });

  listCallItemPrepayModel copyWith({
    String? inv_id,
    int? inv_total,
  }) {
    return listCallItemPrepayModel(
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

  factory listCallItemPrepayModel.fromMap(Map<String, dynamic> map) {
    return listCallItemPrepayModel(
      inv_id: map['inv_id'] ?? '',
      inv_total: map['inv_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory listCallItemPrepayModel.fromJson(String source) =>
      listCallItemPrepayModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'listCallItemPrepayModel(inv_id: $inv_id, inv_total: $inv_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listCallItemPrepayModel &&
        other.inv_id == inv_id &&
        other.inv_total == inv_total;
  }

  @override
  int get hashCode => inv_id.hashCode ^ inv_total.hashCode;
}
