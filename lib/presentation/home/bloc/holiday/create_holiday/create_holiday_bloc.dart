import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/holiday_remote_datasource.dart';

part 'create_holiday_event.dart';
part 'create_holiday_state.dart';
part 'create_holiday_bloc.freezed.dart';

class CreateHolidayBloc extends Bloc<CreateHolidayEvent, CreateHolidayState> {
  final HolidayRemoteDatasource holidayRemoteDatasource;
  CreateHolidayBloc(
    this.holidayRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateHoliday>((event, emit) async {
      emit(const _Loading());
      final result = await holidayRemoteDatasource.addHoliday(
          event.name,
          event.year,
          event.month,
          event.date,
          event.isWeekend,
          event.companyId,
          event.createdBy);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
