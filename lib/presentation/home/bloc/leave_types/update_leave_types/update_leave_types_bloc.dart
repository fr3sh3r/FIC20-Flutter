import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../data/datasources/leave_type_remote_datasource.dart';

part 'update_leave_types_event.dart';
part 'update_leave_types_state.dart';
part 'update_leave_types_bloc.freezed.dart';

class UpdateLeaveTypesBloc
    extends Bloc<UpdateLeaveTypesEvent, UpdateLeaveTypesState> {
  final LeaveTypeRemoteDatasource leaveTypeRemoteDatasource;
  UpdateLeaveTypesBloc(
    this.leaveTypeRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateLeaveTypes>((event, emit) async {
      emit(const _Loading());
      final result = await leaveTypeRemoteDatasource.editLeaveType(
        event.id,
        event.name,
        event.isPaid,
        event.totalLeave,
        event.maxLeavePerMonth,
        event.createdBy,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
