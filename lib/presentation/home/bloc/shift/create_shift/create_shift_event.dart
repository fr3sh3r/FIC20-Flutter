// part of 'create_shift_bloc.dart';

// @freezed
// class CreateShiftEvent with _$CreateShiftEvent {
//   const factory CreateShiftEvent.started() = _Started;
//   const factory CreateShiftEvent.createShift(
//     String name,
//     String clockInTime,
//     String clockOutTime,
//   ) = _CreateShift;
// }

part of 'create_shift_bloc.dart';

@freezed
class CreateShiftEvent with _$CreateShiftEvent {
  const factory CreateShiftEvent.started() = _Started;

  // Menambahkan semua parameter yang dibutuhkan untuk membuat shift
  const factory CreateShiftEvent.createShift({
    required String name,
    required String
        clockInTime, // Anda mungkin perlu menyesuaikan format waktu (misalnya `DateTime`)
    required String
        clockOutTime, // Format waktu juga bisa diubah sesuai kebutuhan
    required int lateMarkAfter,
    required bool isSelfClocking,
    
    required String createdBy, // Tambahkan parameter ini
  }) = _CreateShift;
}
