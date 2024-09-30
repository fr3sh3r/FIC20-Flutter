import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/role_remote_datasource.dart';

part 'delete_role_event.dart';
part 'delete_role_state.dart';
part 'delete_role_bloc.freezed.dart';

class DeleteRoleBloc extends Bloc<DeleteRoleEvent, DeleteRoleState> {
  final RoleRemoteDatasource roleRemoteDatasource;
  DeleteRoleBloc(
    this.roleRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteRole>((event, emit) async {
      emit(const _Loading());
      final result = await roleRemoteDatasource.deleteRole(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
