import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../data/datasources/leave_type_remote_datasource.dart';

part 'delete_leave_types_event.dart';
part 'delete_leave_types_state.dart';
part 'delete_leave_types_bloc.freezed.dart';

class DeleteLeaveTypesBloc
    extends Bloc<DeleteLeaveTypesEvent, DeleteLeaveTypesState> {
  final LeaveTypeRemoteDatasource leaveTypeRemoteDatasource;
  DeleteLeaveTypesBloc(
    this.leaveTypeRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteLeaveTypes>((event, emit) async {
      emit(const _Loading());
      final result = await leaveTypeRemoteDatasource.deleteLeaveType(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
