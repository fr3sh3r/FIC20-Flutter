import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/shift_remote_datasource.dart';

part 'update_shift_event.dart';
part 'update_shift_state.dart';
part 'update_shift_bloc.freezed.dart';

class UpdateShiftBloc extends Bloc<UpdateShiftEvent, UpdateShiftState> {
  final ShiftRemoteDatasource shiftRemoteDatasource;
  UpdateShiftBloc(
    this.shiftRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateShift>((event, emit) async {
      emit(const _Loading());
      final result = await shiftRemoteDatasource.editShift(
          id:event.id,
          name:event.name,
          clockInTime:event.clockInTime,
          clockOutTime:event.clockOutTime, // Positional argument
          lateMarkAfter: event.lateMarkAfter, // Positional argument
          isSelfClocking:event.isSelfClocking //
          );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Updated()),
      );
    });
  }
}
