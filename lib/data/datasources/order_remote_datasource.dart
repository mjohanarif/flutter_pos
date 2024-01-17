import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/model/request/order_request_model.dart';
import 'package:http/http.dart' as http;

class OrderRemoteDatasource {
  Future<bool> sendOrder(OrderRequestModel request) async {
    final url = Uri.parse('${Variables.baseUrl}/api/orders');
    final authData = await AuthLocalDatasource().getAuthData();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: request.toJson(),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
