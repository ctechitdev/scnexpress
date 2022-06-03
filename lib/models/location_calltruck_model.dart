import 'dart:convert';

import 'package:flutter/material.dart';

class locationCallRidderModel {
  final double landx;
  final double landy;
  locationCallRidderModel({
    required this.landx,
    required this.landy,
  });

  locationCallRidderModel copyWith({
    double? landx,
    double? landy,
  }) {
    return locationCallRidderModel(
      landx: landx ?? this.landx,
      landy: landy ?? this.landy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'landx': landx,
      'landy': landy,
    };
  }

  factory locationCallRidderModel.fromMap(Map<String, dynamic> map) {
    return locationCallRidderModel(
      landx: map['landx']?.toDouble() ?? 0.0,
      landy: map['landy']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory locationCallRidderModel.fromJson(String source) =>
      locationCallRidderModel.fromMap(json.decode(source));

  @override
  String toString() => 'locationCallRidderModel(landx: $landx, landy: $landy)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is locationCallRidderModel &&
        other.landx == landx &&
        other.landy == landy;
  }

  @override
  int get hashCode => landx.hashCode ^ landy.hashCode;
}
