import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/holiday_remote_datasource.dart';
import '../../../../../data/models/response/holiday_response_model.dart';

part 'get_holiday_event.dart';
part 'get_holiday_state.dart';
part 'get_holiday_bloc.freezed.dart';

class GetHolidayBloc extends Bloc<GetHolidayEvent, GetHolidayState> {
  final HolidayRemoteDatasource holidayRemoteDatasource;
  GetHolidayBloc(
    this.holidayRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetHolidays>((event, emit) async {
      emit(const _Loading());
      final result = await holidayRemoteDatasource.getHolidays();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
