part of 'get_holiday_bloc.dart';

@freezed
class GetHolidayState with _$GetHolidayState {
  const factory GetHolidayState.initial() = _Initial;
  const factory GetHolidayState.loading() = _Loading;
  const factory GetHolidayState.loaded(List<Holiday> data) = _Loaded;
  const factory GetHolidayState.error(String message) = _Error;
}
