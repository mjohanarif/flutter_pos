import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/order_remote_datasource.dart';
import 'package:flutter_pos/data/model/request/order_request_model.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<_SendOrder>((event, emit) async {
      emit(
        const _Loading(),
      );

      final ordersIsSyncZero =
          await ProductLocalDatasource.instance.getOrderByIsSync();

      for (final order in ordersIsSyncZero) {
        final orderItems = await ProductLocalDatasource.instance
            .getOrderItemByOrderIdLocal(order.id!);

        final orderRequest = OrderRequestModel(
          transactionTime: order.transactionTime,
          totalItem: order.totalQuantity,
          totalPrice: order.totalPrice,
          kasirId: order.idKasir,
          paymentMethod: order.paymentMethod,
          orderItems: orderItems,
        );

        final response = await orderRemoteDatasource.sendOrder(
          orderRequest,
        );
        if (response) {
          await ProductLocalDatasource.instance
              .updateIsSyncOrderById(order.id!);
        }
      }

      emit(
        const _Success(),
      );
    });
  }
}
