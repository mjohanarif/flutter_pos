import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/response/product_response_model.dart';
import 'package:flutter_pos/presentation/home/models/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc()
      : super(
          const _Success([], 0, 0),
        ) {
    on<_AddCheckout>((event, emit) {
      var currentStates = state as _Success;
      List<OrderItem> newCheckout = [...currentStates.products];
      emit(
        const _Loading(),
      );
      if (newCheckout
          .any((element) => element.product.id == event.product.id)) {
        var index = newCheckout
            .indexWhere((element) => element.product.id == event.product.id);
        newCheckout[index].quantity++;
      } else {
        newCheckout.add(
          OrderItem(product: event.product, quantity: 1),
        );
      }

      // int totalQuantity = newCheckout.fold(
      //     0, (previousValue, element) => previousValue + element.quantity);
      int totalQuantity = 0;
      int totalPrice = 0;
      for (var element in newCheckout) {
        totalQuantity += element.quantity;
        totalPrice += element.quantity * element.product.price;
      }

      emit(
        _Success(newCheckout, totalQuantity, totalPrice),
      );
    });

    on<_RemoveCheckout>((event, emit) {
      var currentStates = state as _Success;
      List<OrderItem> newCheckout = [...currentStates.products];

      emit(
        const _Loading(),
      );

      if (newCheckout
          .any((element) => element.product.id == event.product.id)) {
        var index = newCheckout
            .indexWhere((element) => element.product.id == event.product.id);
        if (newCheckout[index].quantity > 1) {
          newCheckout[index].quantity--;
        } else {
          newCheckout.removeAt(index);
        }
      }

      // int totalQuantity = newCheckout.fold(
      //     0, (previousValue, element) => previousValue + element.quantity);
      int totalQuantity = 0;
      int totalPrice = 0;
      for (var element in newCheckout) {
        totalQuantity += element.quantity;
        totalPrice += element.quantity * element.product.price;
      }

      emit(
        _Success(newCheckout, totalQuantity, totalPrice),
      );
    });

    on<_Started>((event, emit) {
      emit(
        const _Loading(),
      );

      emit(
        const _Success([], 0, 0),
      );
    });
  }
}
