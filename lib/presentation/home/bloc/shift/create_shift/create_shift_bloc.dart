import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/shift_remote_datasource.dart';
import 'dart:developer' as developer;
part 'create_shift_event.dart';
part 'create_shift_state.dart';
part 'create_shift_bloc.freezed.dart';

class CreateShiftBloc extends Bloc<CreateShiftEvent, CreateShiftState> {
  final ShiftRemoteDatasource shiftRemoteDatasource;
  CreateShiftBloc(
    this.shiftRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateShift>((event, emit) async {
      emit(const _Loading());
      // Panggil metode addShift dari shiftRemoteDatasource
      final result = await shiftRemoteDatasource.addShift(
          event.name, // Positional argument
          event.clockInTime, // Positional argument
          event.clockOutTime, // Positional argument
          event.lateMarkAfter, // Positional argument
          event.isSelfClocking // Positional argument
          );
      // result.fold(
      //   (l) => emit(_Error(l)),
      //   (r) => emit(const _Success()),
      // );

      result.fold(
        (l) {
          developer.log('Error creating shift: $l');
          emit(_Error(l));
        },
        (r) {
          developer.log('Shift created successfully: $r');
          emit(const _Success());
        },
      );
    });
  }
}
