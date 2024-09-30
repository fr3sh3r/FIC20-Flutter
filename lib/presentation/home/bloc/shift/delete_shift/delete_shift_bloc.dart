import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/shift_remote_datasource.dart';

part 'delete_shift_event.dart';
part 'delete_shift_state.dart';
part 'delete_shift_bloc.freezed.dart';

class DeleteShiftBloc extends Bloc<DeleteShiftEvent, DeleteShiftState> {
  final ShiftRemoteDatasource shiftRemoteDatasource;
  DeleteShiftBloc(
    this.shiftRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteShift>((event, emit) async {
      emit(const _Loading());
      final result = await shiftRemoteDatasource.deleteShift(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
