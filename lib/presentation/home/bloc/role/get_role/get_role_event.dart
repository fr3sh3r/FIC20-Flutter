part of 'get_role_bloc.dart';

@freezed
class GetRoleEvent with _$GetRoleEvent {
  const factory GetRoleEvent.started() = _Started;
  const factory GetRoleEvent.getRoles() = _GetRoles;
  
}