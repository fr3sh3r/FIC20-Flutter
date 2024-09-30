part of 'delete_role_bloc.dart';

@freezed
class DeleteRoleState with _$DeleteRoleState {
  const factory DeleteRoleState.initial() = _Initial;
  const factory DeleteRoleState.loading() = _Loading;
  const factory DeleteRoleState.deleted() = _Deleted;
  const factory DeleteRoleState.error(String message) = _Error;
}
