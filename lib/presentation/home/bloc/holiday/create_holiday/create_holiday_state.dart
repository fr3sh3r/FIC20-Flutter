part of 'create_holiday_bloc.dart';

@freezed
class CreateHolidayState with _$CreateHolidayState {
  const factory CreateHolidayState.initial() = _Initial;
  const factory CreateHolidayState.loading() = _Loading;
  const factory CreateHolidayState.created() = _Created;
  const factory CreateHolidayState.error(String message) = _Error;
}
