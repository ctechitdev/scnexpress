// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class listBillDetailPrintModel {
  final String origin_branch_name;
  final String origin_provin_name;
  final String destination_branch_id;
  final String des_provin_name;
  final String status_pay;
  final String mtl_cusdeposit_fname;
  final String mobi_cusdeposit_number;
  final String add_date;
  final String mtl_recipient_name;
  final String mtl_recipient_tel;
  final String mtl_total_price;
  listBillDetailPrintModel({
    required this.origin_branch_name,
    required this.origin_provin_name,
    required this.destination_branch_id,
    required this.des_provin_name,
    required this.status_pay,
    required this.mtl_cusdeposit_fname,
    required this.mobi_cusdeposit_number,
    required this.add_date,
    required this.mtl_recipient_name,
    required this.mtl_recipient_tel,
    required this.mtl_total_price,
  });

  listBillDetailPrintModel copyWith({
    String? origin_branch_name,
    String? origin_provin_name,
    String? destination_branch_id,
    String? des_provin_name,
    String? status_pay,
    String? mtl_cusdeposit_fname,
    String? mobi_cusdeposit_number,
    String? add_date,
    String? mtl_recipient_name,
    String? mtl_recipient_tel,
    String? mtl_total_price,
  }) {
    return listBillDetailPrintModel(
      origin_branch_name: origin_branch_name ?? this.origin_branch_name,
      origin_provin_name: origin_provin_name ?? this.origin_provin_name,
      destination_branch_id:
          destination_branch_id ?? this.destination_branch_id,
      des_provin_name: des_provin_name ?? this.des_provin_name,
      status_pay: status_pay ?? this.status_pay,
      mtl_cusdeposit_fname: mtl_cusdeposit_fname ?? this.mtl_cusdeposit_fname,
      mobi_cusdeposit_number:
          mobi_cusdeposit_number ?? this.mobi_cusdeposit_number,
      add_date: add_date ?? this.add_date,
      mtl_recipient_name: mtl_recipient_name ?? this.mtl_recipient_name,
      mtl_recipient_tel: mtl_recipient_tel ?? this.mtl_recipient_tel,
      mtl_total_price: mtl_total_price ?? this.mtl_total_price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'origin_branch_name': origin_branch_name,
      'origin_provin_name': origin_provin_name,
      'destination_branch_id': destination_branch_id,
      'des_provin_name': des_provin_name,
      'status_pay': status_pay,
      'mtl_cusdeposit_fname': mtl_cusdeposit_fname,
      'mobi_cusdeposit_number': mobi_cusdeposit_number,
      'add_date': add_date,
      'mtl_recipient_name': mtl_recipient_name,
      'mtl_recipient_tel': mtl_recipient_tel,
      'mtl_total_price': mtl_total_price,
    };
  }

  factory listBillDetailPrintModel.fromMap(Map<String, dynamic> map) {
    return listBillDetailPrintModel(
      origin_branch_name: map['origin_branch_name'] as String,
      origin_provin_name: map['origin_provin_name'] as String,
      destination_branch_id: map['destination_branch_id'] as String,
      des_provin_name: map['des_provin_name'] as String,
      status_pay: map['status_pay'] as String,
      mtl_cusdeposit_fname: map['mtl_cusdeposit_fname'] as String,
      mobi_cusdeposit_number: map['mobi_cusdeposit_number'] as String,
      add_date: map['add_date'] as String,
      mtl_recipient_name: map['mtl_recipient_name'] as String,
      mtl_recipient_tel: map['mtl_recipient_tel'] as String,
      mtl_total_price: map['mtl_total_price'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory listBillDetailPrintModel.fromJson(String source) =>
      listBillDetailPrintModel
          .fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'listBillDetailPrintModel(origin_branch_name: $origin_branch_name, origin_provin_name: $origin_provin_name, destination_branch_id: $destination_branch_id, des_provin_name: $des_provin_name, status_pay: $status_pay, mtl_cusdeposit_fname: $mtl_cusdeposit_fname, mobi_cusdeposit_number: $mobi_cusdeposit_number, add_date: $add_date, mtl_recipient_name: $mtl_recipient_name, mtl_recipient_tel: $mtl_recipient_tel, mtl_total_price: $mtl_total_price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is listBillDetailPrintModel &&
        other.origin_branch_name == origin_branch_name &&
        other.origin_provin_name == origin_provin_name &&
        other.destination_branch_id == destination_branch_id &&
        other.des_provin_name == des_provin_name &&
        other.status_pay == status_pay &&
        other.mtl_cusdeposit_fname == mtl_cusdeposit_fname &&
        other.mobi_cusdeposit_number == mobi_cusdeposit_number &&
        other.add_date == add_date &&
        other.mtl_recipient_name == mtl_recipient_name &&
        other.mtl_recipient_tel == mtl_recipient_tel &&
        other.mtl_total_price == mtl_total_price;
  }

  @override
  int get hashCode {
    return origin_branch_name.hashCode ^
        origin_provin_name.hashCode ^
        destination_branch_id.hashCode ^
        des_provin_name.hashCode ^
        status_pay.hashCode ^
        mtl_cusdeposit_fname.hashCode ^
        mobi_cusdeposit_number.hashCode ^
        add_date.hashCode ^
        mtl_recipient_name.hashCode ^
        mtl_recipient_tel.hashCode ^
        mtl_total_price.hashCode;
  }
}
