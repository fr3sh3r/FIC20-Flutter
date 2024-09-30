part of 'delete_holiday_bloc.dart';

@freezed
class DeleteHolidayState with _$DeleteHolidayState {
  const factory DeleteHolidayState.initial() = _Initial;
  const factory DeleteHolidayState.loading() = _Loading;
  const factory DeleteHolidayState.deleted() = _Deleted;
  const factory DeleteHolidayState.error(String message) = _Error;
}
