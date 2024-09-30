import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/leave_type_remote_datasource.dart';

part 'create_leave_types_event.dart';
part 'create_leave_types_state.dart';
part 'create_leave_types_bloc.freezed.dart';

class CreateLeaveTypesBloc
    extends Bloc<CreateLeaveTypesEvent, CreateLeaveTypesState> {
  final LeaveTypeRemoteDatasource leaveTypeRemoteDatasource;
  CreateLeaveTypesBloc(
    this.leaveTypeRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateLeaveTypes>((event, emit) async {
      emit(const _Loading());
      final result = await leaveTypeRemoteDatasource.addLeaveType(
        event.name,
        event.isPaid,
        event.totalLeaves,
        event.maxLeavePerMonth,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
