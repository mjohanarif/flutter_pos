import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_pos/presentation/home/models/order_item.dart';

class OrderModel {
  final int? id;
  final String paymentMethod;
  final int nominalBayar;
  final List<OrderItem> orders;
  final int totalQuantity;
  final int totalPrice;
  final int idKasir;
  final String namaKasir;
  final String transactionTime;
  final bool isSync;

  OrderModel({
    this.id,
    required this.paymentMethod,
    required this.nominalBayar,
    required this.orders,
    required this.totalQuantity,
    required this.totalPrice,
    required this.idKasir,
    required this.namaKasir,
    required this.isSync,
    required this.transactionTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentMethod': paymentMethod,
      'nominalBayar': nominalBayar,
      'orders': orders.map((x) => x.toMap()).toList(),
      'totalQuantity': totalQuantity,
      'totalPrice': totalPrice,
      'idKasir': idKasir,
      'namaKasir': namaKasir,
      'isSync': isSync,
    };
  }

  Map<String, dynamic> toMapForLocal() {
    return <String, dynamic>{
      'payment_method': paymentMethod,
      'total_item': totalQuantity,
      'nominal': totalPrice,
      'id_kasir': idKasir,
      'nama_kasir': namaKasir,
      'is_sync': isSync ? 1 : 0,
      'transaction_time': transactionTime,
    };
  }

  factory OrderModel.fromLocalMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['payment_method'] as String,
      nominalBayar: map['nominal'] as int,
      orders: List<OrderItem>.from(
        (map['orders'])?.map<OrderItem>(
              (x) => OrderItem.fromMap(x as Map<String, dynamic>),
            ) ??
            [],
      ),
      totalQuantity: map['total_item'] as int,
      totalPrice: map['nominal'] as int,
      idKasir: map['id_kasir'] as int,
      namaKasir: map['nama_kasir'] as String,
      isSync: map['is_sync'] == 1 ? true : false,
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transaction_time'] ?? '',
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['paymentMethod'] as String,
      nominalBayar: map['nominalBayar'] as int,
      orders: List<OrderItem>.from(
        (map['orders'] as List<int>).map<OrderItem>(
          (x) => OrderItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalQuantity: map['totalQuantity'] as int,
      totalPrice: map['totalPrice'] as int,
      idKasir: map['idKasir'] as int,
      namaKasir: map['namaKasir'] as String,
      isSync: map['is_sync'] as bool,
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transaction_time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(paymentMethod: $paymentMethod, nominalBayar: $nominalBayar, orders: $orders, totalQuantity: $totalQuantity, totalPrice: $totalPrice, idKasir: $idKasir, namaKasir: $namaKasir, isSync: $isSync)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.paymentMethod == paymentMethod &&
        other.nominalBayar == nominalBayar &&
        listEquals(other.orders, orders) &&
        other.totalQuantity == totalQuantity &&
        other.totalPrice == totalPrice &&
        other.idKasir == idKasir &&
        other.namaKasir == namaKasir &&
        other.isSync == isSync;
  }

  @override
  int get hashCode {
    return paymentMethod.hashCode ^
        nominalBayar.hashCode ^
        orders.hashCode ^
        totalQuantity.hashCode ^
        totalPrice.hashCode ^
        idKasir.hashCode ^
        namaKasir.hashCode ^
        isSync.hashCode;
  }
}
