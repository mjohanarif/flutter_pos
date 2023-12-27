import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  List<Product> products = [];
  ProductBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Fetch>(
      (event, emit) async {
        emit(
          const _Loading(),
        );

        final response = await productRemoteDatasource.getProducts();

        response.fold(
          (l) => emit(
            _Error(l),
          ),
          (r) {
            products = r.data;
            emit(
              _Success(r.data),
            );
          },
        );
      },
    );

    on<_FetchByCategory>(
      (event, emit) async {
        emit(
          const _Loading(),
        );

        final newProducts = event.category == 'all'
            ? products
            : products
                .where((element) => element.category == event.category)
                .toList();

        emit(
          _Success(newProducts),
        );
      },
    );

    on<_FetchLocal>(
      (event, emit) async {
        emit(
          const _Loading(),
        );

        final localProducts =
            await ProductLocalDatasource.instance.getAllProduct();
        products = localProducts;

        emit(
          _Success(products),
        );
      },
    );
  }
}
