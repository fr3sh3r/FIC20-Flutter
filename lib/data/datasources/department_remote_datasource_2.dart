import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Untuk menangani exception terkait koneksi
import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/data/models/response/department_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class DepartmentRemoteDatasource {
  static const int timeoutDuration = 10; // Durasi timeout dalam detik
  var logger = Logger(); // Inisialisasi logger

  Future<Either<String, DepartmentResponseModel>> getDepartments() async {
    logger
        .i('SUKSES: getDepartments dipanggil'); // Gantikan print dengan logger
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    try {
      logger.d('Mengirim permintaan ke server'); // Debugging log
      final response = await http
          .get(url, headers: header)
          .timeout(const Duration(seconds: timeoutDuration));

      // logger.d('Status code: ${response.statusCode}');
      // logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Right(DepartmentResponseModel.fromJson(response.body));
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

  Future<Either<String, String>> createDepartment(
      String name, String description) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments');
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

    try {
      final response = await http
          .post(url, headers: header, body: body)
          .timeout(const Duration(seconds: timeoutDuration));

      if (response.statusCode == 201) {
        return const Right('Department berhasil dibuat.');
      } else {
        return Left('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      return const Left('Tidak ada koneksi internet. Silakan coba lagi.');
    } on TimeoutException {
      return const Left('Permintaan waktu habis. Silakan coba lagi.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> updateDepartment(
      int id, String name, String description) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments/$id');
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

    try {
      final response = await http
          .put(url, headers: header, body: body)
          .timeout(const Duration(seconds: timeoutDuration));

      if (response.statusCode == 200) {
        return const Right('Department berhasil diperbarui.');
      } else {
        return Left('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      return const Left('Tidak ada koneksi internet. Silakan coba lagi.');
    } on TimeoutException {
      return const Left('Permintaan waktu habis. Silakan coba lagi.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, String>> deleteDepartment(int id) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments/$id');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    try {
      final response = await http
          .delete(url, headers: header)
          .timeout(const Duration(seconds: timeoutDuration));

      if (response.statusCode == 200) {
        return const Right('Department berhasil dihapus.');
      } else {
        return Left('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      return const Left('Tidak ada koneksi internet. Silakan coba lagi.');
    } on TimeoutException {
      return const Left('Permintaan waktu habis. Silakan coba lagi.');
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
