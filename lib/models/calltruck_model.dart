import 'dart:convert';

class CallTruckListModel {
  final String bill_header;
  final int bill_total;
  CallTruckListModel({
    required this.bill_header,
    required this.bill_total,
  });

  CallTruckListModel copyWith({
    String? bill_header,
    int? bill_total,
  }) {
    return CallTruckListModel(
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

  factory CallTruckListModel.fromMap(Map<String, dynamic> map) {
    return CallTruckListModel(
      bill_header: map['bill_header'] ?? '',
      bill_total: map['bill_total']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallTruckListModel.fromJson(String source) =>
      CallTruckListModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CallTruckListModel(bill_header: $bill_header, bill_total: $bill_total)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CallTruckListModel &&
        other.bill_header == bill_header &&
        other.bill_total == bill_total;
  }

  @override
  int get hashCode => bill_header.hashCode ^ bill_total.hashCode;
}
