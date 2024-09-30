part of 'create_role_bloc.dart';

@freezed
class CreateRoleEvent with _$CreateRoleEvent {
  const factory CreateRoleEvent.started() = _Started;
  const factory CreateRoleEvent.createRole(
    int companyId,
    String name,
    String displayName,
    String description,
  ) = _CreateRole;
}
