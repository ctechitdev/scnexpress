// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class printTestModel {
  final String add_date;
  final String bill_code;
  final String mtl_cusdeposit_fname;
  final String mobi_cusdeposit_number;
  final String origin_branch_name;
  final String origin_branch_tel;
  final String mtl_recipient_name;
  final String mtl_recipient_tel;
  final String destination_branch_name;
  final String destination_branch_tel;
  final String mtl_name;
  final String mtl_am;
  final String mt_name;
  final String status_pay;
  final String from_pay;
  final String to_pay;
  final String tfs_name;
  printTestModel({
    required this.add_date,
    required this.bill_code,
    required this.mtl_cusdeposit_fname,
    required this.mobi_cusdeposit_number,
    required this.origin_branch_name,
    required this.origin_branch_tel,
    required this.mtl_recipient_name,
    required this.mtl_recipient_tel,
    required this.destination_branch_name,
    required this.destination_branch_tel,
    required this.mtl_name,
    required this.mtl_am,
    required this.mt_name,
    required this.status_pay,
    required this.from_pay,
    required this.to_pay,
    required this.tfs_name,
  });

  printTestModel copyWith({
    String? add_date,
    String? bill_code,
    String? mtl_cusdeposit_fname,
    String? mobi_cusdeposit_number,
    String? origin_branch_name,
    String? origin_branch_tel,
    String? mtl_recipient_name,
    String? mtl_recipient_tel,
    String? destination_branch_name,
    String? destination_branch_tel,
    String? mtl_name,
    String? mtl_am,
    String? mt_name,
    String? status_pay,
    String? from_pay,
    String? to_pay,
    String? tfs_name,
  }) {
    return printTestModel(
      add_date: add_date ?? this.add_date,
      bill_code: bill_code ?? this.bill_code,
      mtl_cusdeposit_fname: mtl_cusdeposit_fname ?? this.mtl_cusdeposit_fname,
      mobi_cusdeposit_number:
          mobi_cusdeposit_number ?? this.mobi_cusdeposit_number,
      origin_branch_name: origin_branch_name ?? this.origin_branch_name,
      origin_branch_tel: origin_branch_tel ?? this.origin_branch_tel,
      mtl_recipient_name: mtl_recipient_name ?? this.mtl_recipient_name,
      mtl_recipient_tel: mtl_recipient_tel ?? this.mtl_recipient_tel,
      destination_branch_name:
          destination_branch_name ?? this.destination_branch_name,
      destination_branch_tel:
          destination_branch_tel ?? this.destination_branch_tel,
      mtl_name: mtl_name ?? this.mtl_name,
      mtl_am: mtl_am ?? this.mtl_am,
      mt_name: mt_name ?? this.mt_name,
      status_pay: status_pay ?? this.status_pay,
      from_pay: from_pay ?? this.from_pay,
      to_pay: to_pay ?? this.to_pay,
      tfs_name: tfs_name ?? this.tfs_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'add_date': add_date,
      'bill_code': bill_code,
      'mtl_cusdeposit_fname': mtl_cusdeposit_fname,
      'mobi_cusdeposit_number': mobi_cusdeposit_number,
      'origin_branch_name': origin_branch_name,
      'origin_branch_tel': origin_branch_tel,
      'mtl_recipient_name': mtl_recipient_name,
      'mtl_recipient_tel': mtl_recipient_tel,
      'destination_branch_name': destination_branch_name,
      'destination_branch_tel': destination_branch_tel,
      'mtl_name': mtl_name,
      'mtl_am': mtl_am,
      'mt_name': mt_name,
      'status_pay': status_pay,
      'from_pay': from_pay,
      'to_pay': to_pay,
      'tfs_name': tfs_name,
    };
  }

  factory printTestModel.fromMap(Map<String, dynamic> map) {
    return printTestModel(
      add_date: map['add_date'] as String,
      bill_code: map['bill_code'] as String,
      mtl_cusdeposit_fname: map['mtl_cusdeposit_fname'] as String,
      mobi_cusdeposit_number: map['mobi_cusdeposit_number'] as String,
      origin_branch_name: map['origin_branch_name'] as String,
      origin_branch_tel: map['origin_branch_tel'] as String,
      mtl_recipient_name: map['mtl_recipient_name'] as String,
      mtl_recipient_tel: map['mtl_recipient_tel'] as String,
      destination_branch_name: map['destination_branch_name'] as String,
      destination_branch_tel: map['destination_branch_tel'] as String,
      mtl_name: map['mtl_name'] as String,
      mtl_am: map['mtl_am'] as String,
      mt_name: map['mt_name'] as String,
      status_pay: map['status_pay'] as String,
      from_pay: map['from_pay'] as String,
      to_pay: map['to_pay'] as String,
      tfs_name: map['tfs_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory printTestModel.fromJson(String source) =>
      printTestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'printTestModel(add_date: $add_date, bill_code: $bill_code, mtl_cusdeposit_fname: $mtl_cusdeposit_fname, mobi_cusdeposit_number: $mobi_cusdeposit_number, origin_branch_name: $origin_branch_name, origin_branch_tel: $origin_branch_tel, mtl_recipient_name: $mtl_recipient_name, mtl_recipient_tel: $mtl_recipient_tel, destination_branch_name: $destination_branch_name, destination_branch_tel: $destination_branch_tel, mtl_name: $mtl_name, mtl_am: $mtl_am, mt_name: $mt_name, status_pay: $status_pay, from_pay: $from_pay, to_pay: $to_pay, tfs_name: $tfs_name)';
  }

  @override
  bool operator ==(covariant printTestModel other) {
    if (identical(this, other)) return true;

    return other.add_date == add_date &&
        other.bill_code == bill_code &&
        other.mtl_cusdeposit_fname == mtl_cusdeposit_fname &&
        other.mobi_cusdeposit_number == mobi_cusdeposit_number &&
        other.origin_branch_name == origin_branch_name &&
        other.origin_branch_tel == origin_branch_tel &&
        other.mtl_recipient_name == mtl_recipient_name &&
        other.mtl_recipient_tel == mtl_recipient_tel &&
        other.destination_branch_name == destination_branch_name &&
        other.destination_branch_tel == destination_branch_tel &&
        other.mtl_name == mtl_name &&
        other.mtl_am == mtl_am &&
        other.mt_name == mt_name &&
        other.status_pay == status_pay &&
        other.from_pay == from_pay &&
        other.to_pay == to_pay &&
        other.tfs_name == tfs_name;
  }

  @override
  int get hashCode {
    return add_date.hashCode ^
        bill_code.hashCode ^
        mtl_cusdeposit_fname.hashCode ^
        mobi_cusdeposit_number.hashCode ^
        origin_branch_name.hashCode ^
        origin_branch_tel.hashCode ^
        mtl_recipient_name.hashCode ^
        mtl_recipient_tel.hashCode ^
        destination_branch_name.hashCode ^
        destination_branch_tel.hashCode ^
        mtl_name.hashCode ^
        mtl_am.hashCode ^
        mt_name.hashCode ^
        status_pay.hashCode ^
        from_pay.hashCode ^
        to_pay.hashCode ^
        tfs_name.hashCode;
  }
}
