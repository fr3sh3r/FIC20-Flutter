import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/shift_remote_datasource.dart';
import '../../../../../data/models/response/shift_response_model.dart';

part 'get_shift_event.dart';
part 'get_shift_state.dart';
part 'get_shift_bloc.freezed.dart';

class GetShiftBloc extends Bloc<GetShiftEvent, GetShiftState> {
  final ShiftRemoteDatasource shiftRemoteDatasource;
  GetShiftBloc(
    this.shiftRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetShift>((event, emit) async {
      emit(const _Loading());
      final result = await shiftRemoteDatasource.getShifts();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
