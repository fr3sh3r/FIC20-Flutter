import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final url = Uri.parse(
        '${Variables.baseUrl}/api/login'); //kirim email dan password ke server, apakah credential matched? point #4 di bawah
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response
          .body)); //kalau sukses , RETURN ke Bloc bahwa ini sukses point #5 di bawah
    } else {
      return Left(response.body); //kalau gagal
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

  //logout
  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final url = Uri.parse('${Variables.baseUrl}/api/logout');
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final response = await http.post(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      return const Right('Logout success');
    } else {
      return Left(response.body);
    }
  }
}
