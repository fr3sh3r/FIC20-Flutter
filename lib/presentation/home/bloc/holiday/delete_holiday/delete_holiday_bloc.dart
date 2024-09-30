import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/holiday_remote_datasource.dart';

part 'delete_holiday_event.dart';
part 'delete_holiday_state.dart';
part 'delete_holiday_bloc.freezed.dart';

class DeleteHolidayBloc extends Bloc<DeleteHolidayEvent, DeleteHolidayState> {
  final HolidayRemoteDatasource holidayRemoteDatasource;
  DeleteHolidayBloc(
    this.holidayRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteHoliday>((event, emit) async {
      emit(const _Loading());
      final result = await holidayRemoteDatasource.deleteHoliday(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
