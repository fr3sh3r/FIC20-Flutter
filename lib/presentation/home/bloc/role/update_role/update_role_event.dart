part of 'update_role_bloc.dart';

@freezed
class UpdateRoleEvent with _$UpdateRoleEvent {
  const factory UpdateRoleEvent.started() = _Started;
  const factory UpdateRoleEvent.updateRole(
    int id,
    int companyId,
    String name,
    String displayName,
    String description,
  ) = _UpdateRole;
}