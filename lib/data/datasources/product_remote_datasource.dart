import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse(
        '${Variables.baseUrl}/api/products',
      ),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      return Right(
        ProductResponseModel.fromRawJson(response.body),
      );
    } else {
      return Left(response.body);
    }
  }
}
