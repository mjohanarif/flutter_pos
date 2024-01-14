part of 'qris_bloc.dart';

@freezed
class QrisState with _$QrisState {
  const factory QrisState.initial() = _Initial;
  const factory QrisState.loading() = _Loading;
  const factory QrisState.qrisResponse(QrisResponseModel response) =
      _QrisResponse;
  const factory QrisState.success(String response) = _Success;
  const factory QrisState.statusCheck(
      QrisStatusResponseModel qrisStatusResponseModel) = _StatusCheck;
  const factory QrisState.error(String message) = _Error;
}
