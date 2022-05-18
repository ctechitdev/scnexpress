import 'dart:convert';

class AcceptCallTruckList {
  final String bill_header;
  final int bill_total;
  AcceptCallTruckList({
    required this.bill_header,
    required this.bill_total,
  });

  AcceptCallTruckList copyWith({
    String? bill_header,
    int? bill_total,
  }) {
    return AcceptCallTruckList(
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

  factory AcceptCallTruckList.fromMap(Map<String, dynamic> map) {
    return AcceptCallTruckList(
      bill_header: map['bill_header'] ?? '',
      bill_total: map['bill_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AcceptCallTruckList.fromJson(String source) =>
      AcceptCallTruckList.fromMap(json.decode(source));

  @override
  String toString() =>
      'AcceptCallTruckList(bill_header: $bill_header, bill_total: $bill_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AcceptCallTruckList &&
        other.bill_header == bill_header &&
        other.bill_total == bill_total;
  }

  @override
  int get hashCode => bill_header.hashCode ^ bill_total.hashCode;
}
