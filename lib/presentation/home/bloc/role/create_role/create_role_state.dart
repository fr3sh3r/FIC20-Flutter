part of 'create_role_bloc.dart';

@freezed
class CreateRoleState with _$CreateRoleState {
  const factory CreateRoleState.initial() = _Initial;
  const factory CreateRoleState.loading() = _Loading;
  const factory CreateRoleState.created() = _Created;
  const factory CreateRoleState.error(String message) = _Error;
}
