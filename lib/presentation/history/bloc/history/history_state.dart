part of 'history_bloc.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState.initial() = _Initial;
  const factory HistoryState.loading() = _Loading;
  const factory HistoryState.success(List<OrderModel> histories) = _Success;
  const factory HistoryState.errir(String message) = _Error;
}
