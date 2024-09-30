part of 'get_designation_bloc.dart';

@freezed
class GetDesignationEvent with _$GetDesignationEvent {
  const factory GetDesignationEvent.started() = _Started;  
  const factory GetDesignationEvent.getDesignations() = _GetDesignations;
}