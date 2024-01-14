import 'dart:convert';

import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/model/response/qris_response_model.dart';
import 'package:flutter_pos/data/model/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(
      utf8.encode('$serverKey:'),
    );

    return 'Basic $base64Credentials';
  }

  Future<QrisResponseModel> generateQrCode(
    String orderId,
    int grossAmount,
  ) async {
    final serverKey = await AuthLocalDatasource().getMidtransServerKey();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final body = jsonEncode({
      "payment_type": "gopay",
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": grossAmount,
      }
    });

    final response = await http.post(
      Uri.parse(
        'https://api.sandbox.midtrans.com/v2/charge',
      ),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisResponseModel.fromJson(
        response.body,
      );
    } else {
      throw Exception('Failed to generate qr code');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final serverKey = await AuthLocalDatasource().getMidtransServerKey();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    final response = await http.get(
      Uri.parse(
        'https://api.sandbox.midtrans.com/v2/$orderId/status',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(
        response.body,
      );
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}
