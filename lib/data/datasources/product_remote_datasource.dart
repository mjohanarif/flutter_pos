import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/model/request/product_request_model.dart';
import 'package:flutter_pos/data/model/response/add_product_response_model.dart';
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

  Future<Either<String, AddProductResponseModel>> addProduct(
    ProductRequestModel productRequestModel,
  ) async {
    final authData = await AuthLocalDatasource().getAuthData();

    final Map<String, String> headers = {
      'Authorization': 'Bearer ${authData.token}',
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${Variables.baseUrl}/api/products'),
    );

    request.fields.addAll(
      productRequestModel.toMap(),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
          'image', productRequestModel.image.path),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final String body = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return Right(
        AddProductResponseModel.fromRawJson(body),
      );
    } else {
      return Left(body);
    }
  }
}
