part of 'delete_shift_bloc.dart';

@freezed
class DeleteShiftState with _$DeleteShiftState {
  const factory DeleteShiftState.initial() = _Initial;
  const factory DeleteShiftState.loading() = _Loading;
  const factory DeleteShiftState.deleted() = _Deleted;
  const factory DeleteShiftState.error(String message) = _Error;
}
