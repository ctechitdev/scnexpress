import 'dart:convert';

class CallRidderNotAcceptModel {
  final String bill_header;
  final int bill_total;
  CallRidderNotAcceptModel({
    required this.bill_header,
    required this.bill_total,
  });

  CallRidderNotAcceptModel copyWith({
    String? bill_header,
    int? bill_total,
  }) {
    return CallRidderNotAcceptModel(
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

  factory CallRidderNotAcceptModel.fromMap(Map<String, dynamic> map) {
    return CallRidderNotAcceptModel(
      bill_header: map['bill_header'] ?? '',
      bill_total: map['bill_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallRidderNotAcceptModel.fromJson(String source) =>
      CallRidderNotAcceptModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CallRidderNotAcceptModel(bill_header: $bill_header, bill_total: $bill_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CallRidderNotAcceptModel &&
        other.bill_header == bill_header &&
        other.bill_total == bill_total;
  }

  @override
  int get hashCode => bill_header.hashCode ^ bill_total.hashCode;
}
