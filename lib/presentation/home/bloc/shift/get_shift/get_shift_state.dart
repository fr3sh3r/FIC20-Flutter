part of 'get_shift_bloc.dart';

@freezed
class GetShiftState with _$GetShiftState {
  const factory GetShiftState.initial() = _Initial;
  const factory GetShiftState.loading() = _Loading;
  const factory GetShiftState.loaded(List<Shift> data) = _Loaded;
  const factory GetShiftState.error(String message) = _Error;
}
