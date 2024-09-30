import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Untuk menangani exception terkait koneksi
import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/data/models/response/department_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

//untuk membuat Datasource lain dengan mengcopy Datasource ini
//1. Replace Department with NamaEndpoint yang akan dibuat, misalnya Shift ,
//   sehingga semua nama method (class) dan ReponseModel akan ikut berubah nama
//2. ganti MyEndPoint = "shifts" (sesuai Endpoint yang di route.api)

class DepartmentRemoteDatasource {
  static const int timeoutDuration = 10; // Durasi timeout dalam detik
  var logger = Logger(); // Inisialisasi logger

  // Deklarasi satu variabel untuk endpoint di awal
  final String myEndPoint = "departments"; //ini yang dirubah

  // URL getter   === > harus pakai cara ini
  // final Uri myUrl = Uri.parse('${Variables.baseUrl}/api/api-$myEndPoint'); //gabisa pakai ini

  Uri get myUrl => Uri.parse('${Variables.baseUrl}/api/api-$myEndPoint');

  // Fungsi handler untuk HTTP request
  Future<Either<String, T>> requestHandler<T>(
    Future<http.Response> Function() request,
    T Function(http.Response response) onSuccess,
  ) async {
    try {
      final response = await request().timeout(
        const Duration(seconds: timeoutDuration),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Right(onSuccess(response));
      } else {
        return Left('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      logger.e('Tidak ada koneksi internet');
      return const Left('Tidak ada koneksi internet. Silakan coba lagi.');
    } on TimeoutException {
      logger.e('Permintaan waktu habis');
      return const Left('Permintaan waktu habis. Silakan coba lagi.');
    } catch (e) {
      logger.e('Terjadi kesalahan: $e');
      return Left('Terjadi kesalahan: $e');
    }
  }

  // getALL / index
  Future<Either<String, DepartmentResponseModel>> getDepartments() async {
    logger.i('SUKSES: $myEndPoint dipanggil');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    return requestHandler(() => http.get(myUrl, headers: header),
        (response) => DepartmentResponseModel.fromJson(response.body));
  }

  // add / create
  Future<Either<String, String>> createDepartment(
      String name, String description) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final String body = jsonEncode({
      'name': name,
      'description': description,
    });

    return requestHandler(() => http.post(myUrl, headers: header, body: body),
        (response) => '$myEndPoint berhasil dibuat.');
  }

  // edit / update
  Future<Either<String, String>> updateDepartment(
      int id, String name, String description) async {
    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final String body = jsonEncode({
      'name': name,
      'description': description,
    });

    return requestHandler(
        () => http.put(urlWithId, headers: header, body: body),
        (response) => '$myEndPoint berhasil diperbarui.');
  }

  // Delete
  Future<Either<String, String>> deleteDepartment(int id) async {
    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    return requestHandler(() => http.delete(urlWithId, headers: header),
        (response) => '$myEndPoint berhasil dihapus.');
  }
}
