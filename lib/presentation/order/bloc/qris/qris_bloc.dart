import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_pos/data/model/response/qris_response_model.dart';
import 'package:flutter_pos/data/model/response/qris_status_response_model.dart';

part 'qris_bloc.freezed.dart';
part 'qris_event.dart';
part 'qris_state.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  final MidtransRemoteDatasource midtransRemoteDatasource;
  QrisBloc(
    this.midtransRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GenerateQrCode>((event, emit) async {
      emit(const _Loading());
      final response = await midtransRemoteDatasource.generateQrCode(
          event.orderId, event.grossAmount);

      emit(
        _QrisResponse(response),
      );
    });

    on<_CheckPaymentStatus>((event, emit) async {
      // emit(const _Loading());
      final response = await midtransRemoteDatasource.checkPaymentStatus(
        event.orderId,
      );

      if (response.transactionStatus == 'settlement') {
        emit(
          const _Success('Pembayaran Berhasil'),
        );
      }
      // else {
      //   emit(
      //     _StatusCheck(response),
      //   );
      // }
    });
  }
}
