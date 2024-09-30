part of 'get_shift_bloc.dart';

@freezed
class GetShiftEvent with _$GetShiftEvent {
  const factory GetShiftEvent.started() = _Started;
  const factory GetShiftEvent.getShift() = _GetShift;
  
}