import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/holiday_remote_datasource.dart';

part 'update_holiday_event.dart';
part 'update_holiday_state.dart';
part 'update_holiday_bloc.freezed.dart';

class UpdateHolidayBloc extends Bloc<UpdateHolidayEvent, UpdateHolidayState> {
  final HolidayRemoteDatasource holidayRemoteDatasource;
  UpdateHolidayBloc(
    this.holidayRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateHoliday>((event, emit) async {
      emit(const _Loading());
      final result = await holidayRemoteDatasource.editHoliday(
          event.id,
          event.name,
          event.year,
          event.month,
          event.date,
          event.isWeekend,
          event.companyId,
          event.createdBy);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Updated()),
      );
    });
  }
}
