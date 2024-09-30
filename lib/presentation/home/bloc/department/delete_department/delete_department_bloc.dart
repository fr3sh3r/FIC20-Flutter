import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/department_remote_datasource.dart';

part 'delete_department_bloc.freezed.dart';
part 'delete_department_event.dart';
part 'delete_department_state.dart';

class DeleteDepartmentBloc
    extends Bloc<DeleteDepartmentEvent, DeleteDepartmentState> {
  final DepartmentRemoteDatasource departmentRemoteDatasource;
  DeleteDepartmentBloc(
    this.departmentRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteDepartment>((event, emit) async {
      emit(const _Loading());
      final result =
          await departmentRemoteDatasource.deleteDepartment(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
