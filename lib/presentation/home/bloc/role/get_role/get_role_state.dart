part of 'get_role_bloc.dart';

@freezed
class GetRoleState with _$GetRoleState {
  const factory GetRoleState.initial() = _Initial;
  const factory GetRoleState.loading() = _Loading;
  const factory GetRoleState.loaded(List<Role> data) = _Loaded;
  const factory GetRoleState.error(String message) = _Error;
}
