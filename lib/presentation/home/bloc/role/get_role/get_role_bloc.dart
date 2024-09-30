import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/role_remote_datasource.dart';
import '../../../../../data/models/response/role_reponse_model.dart';

part 'get_role_event.dart';
part 'get_role_state.dart';
part 'get_role_bloc.freezed.dart';

class GetRoleBloc extends Bloc<GetRoleEvent, GetRoleState> {
  final RoleRemoteDatasource roleRemoteDatasource;
  GetRoleBloc(
    this.roleRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetRoles>((event, emit) async {
      emit(const _Loading());
      final result = await roleRemoteDatasource.getRoles();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
