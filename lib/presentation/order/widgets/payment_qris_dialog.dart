import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:flutter_pos/presentation/order/widgets/payment_success_dialog.dart';
import 'package:intl/intl.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../data/datasources/product_local_datasource.dart';
import '../bloc/order/order_bloc.dart';
import '../models/order_model.dart';

class PaymentQrisDialog extends StatefulWidget {
  final int price;
  const PaymentQrisDialog({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  Timer? timer;
  @override
  void initState() {
    orderId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<QrisBloc>().add(QrisEvent.generateQrCode(
          orderId,
          widget.price,
        ));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.primary,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Pembayaran QRIS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          const SpaceHeight(6.0),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(orElse: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, success: (
                products,
                totalQuantity,
                totalPrice,
                paymentMethod,
                nominalBayar,
                idKasir,
                namaKasir,
              ) {
                return Container(
                  width: context.deviceWidth,
                  padding: const EdgeInsets.all(14.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: AppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocListener<QrisBloc, QrisState>(
                        listener: (context, state) {
                          state.maybeWhen(orElse: () {
                            return;
                          }, qrisResponse: (data) {
                            const onSec = Duration(seconds: 5);
                            timer = Timer.periodic(onSec, (timer) {
                              if (mounted) {
                                context
                                    .read<QrisBloc>()
                                    .add(QrisEvent.checkPaymentStatus(
                                      orderId,
                                    ));
                              }
                            });
                          }, success: (message) {
                            timer?.cancel();

                            final orderModel = OrderModel(
                              paymentMethod: paymentMethod,
                              nominalBayar: totalPrice,
                              orders: products,
                              totalQuantity: totalQuantity,
                              totalPrice: totalPrice,
                              idKasir: idKasir,
                              namaKasir: namaKasir,
                              isSync: false,
                              transactionTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
                                  .format(DateTime.now()),
                            );

                            ProductLocalDatasource.instance
                                .saveOrder(orderModel);
                            context.pop();
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const PaymentSuccessDialog(),
                            );
                          });
                        },
                        child: BlocBuilder<QrisBloc, QrisState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () {
                                return const SizedBox();
                              },
                              qrisResponse: (data) {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      data.actions!.first.url!,
                                    ),
                                  ),
                                );
                              },
                              loading: () {
                                return Container(
                                  width: 256.0,
                                  height: 256.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SpaceHeight(5.0),
                      const Text(
                        'Scan QRIS untuk melakukan pembayaran',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
