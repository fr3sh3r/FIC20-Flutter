// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_remote_datasource.dart';

import '../../../../data/models/response/auth_response_model.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource authRemoteDatasource;

  LoginBloc(
    this.authRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      //point no 2
      emit(const _Loading()); //point no 3

      final result = await authRemoteDatasource.login(
          //point no 4, melempar ke authRemoteDatasource , dan await
          event.email,
          event.password);

      //di sini result sudah keluar
      result.fold(
        (l) => emit(_Error(l)), //point 8
        (r) => emit(_Loaded(r)), //point 9
      );
    });
  }
}


// Alur Kerja:
// 1. Pengguna memasukkan email dan password.
// 2. Event _Login dengan email dan password dikirim ke LoginBloc.
// 3. LoginBloc mengubah state menjadi _Loading untuk menunjukkan proses sedang berlangsung.
// 4. LoginBloc memanggil authRemoteDatasource.login untuk melakukan request login ke server.
// 5. Server merespon dengan sukses atau error.
// 6. LoginBloc menerima respon server (result).
// 7. Berdasarkan respon, LoginBloc mengubah state:
// 8. _Error jika terjadi error (menampilkan pesan error ke pengguna).
// 9. _Loaded jika login berhasil (mengirimkan data login ke bagian lain aplikasi).


// Alternatif Tanpa fold:

// Meskipun fold direkomendasikan, Anda dapat mencapai hasil yang sama tanpa menggunakannya, namun mungkin kurang efisien:

// on<_Login>((event, emit) async {
//   emit(const _Loading());
//   final result = await authRemoteDatasource.login(event.email, event.password);
//   if (result is Left) {
//     emit(_Error(result.left));
//   } else {
//     emit(_Loaded(result.right));
//   }
// });