import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../data/datasources/leave_type_remote_datasource.dart';
import '../../../../../data/models/response/leave_tyoe_response_model.dart';

part 'get_leave_types_event.dart';
part 'get_leave_types_state.dart';
part 'get_leave_types_bloc.freezed.dart';

class GetLeaveTypesBloc extends Bloc<GetLeaveTypesEvent, GetLeaveTypesState> {
  final LeaveTypeRemoteDatasource leaveTypeRemoteDatasource;
  GetLeaveTypesBloc(
    this.leaveTypeRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetLeaveTypes>((event, emit) async {
      emit(const _Loading());
      final result = await leaveTypeRemoteDatasource.getLeaveTypes();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}

