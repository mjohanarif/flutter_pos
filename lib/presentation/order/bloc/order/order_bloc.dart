import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/home/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Success([], 0, 0, '', 0, 0, '')) {
    on<_AddPaymentMethod>((event, emit) {
      emit(
        const _Loading(),
      );
      emit(
        _Success(
            event.orders,
            event.orders.fold(0,
                (previousValue, element) => previousValue + element.quantity),
            event.orders.fold(
                0,
                (previousValue, element) =>
                    previousValue + (element.product.price * element.quantity)),
            event.paymentMethod,
            0,
            0,
            ''),
      );
    });

    on<_AddNominalBayar>((event, emit) {
      var currentStates = state as _Success;

      emit(
        const _Loading(),
      );

      emit(
        _Success(
          currentStates.products,
          currentStates.totalQuantity,
          currentStates.totalPrice,
          currentStates.paymentMethod,
          event.nominal,
          currentStates.idKasir,
          currentStates.namaKasir,
        ),
      );
    });

    on<_Started>((event, emit) {
      emit(
        const _Loading(),
      );

      emit(
        const _Success([], 0, 0, '', 0, 0, ''),
      );
    });
  }
}
