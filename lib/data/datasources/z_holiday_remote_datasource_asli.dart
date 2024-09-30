import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Untuk menangani exception terkait koneksi
import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../models/response/holiday_response_model.dart';

// Template untuk Tabel Lainnya
class HolidayRemoteDatasource {
  static const int timeoutDuration = 10; // Durasi timeout dalam detik
  var logger = Logger(); // Inisialisasi logger

  // Deklarasi variabel untuk endpoint
  final String myEndPoint = "holidays"; // Ganti sesuai nama endpoint

  // URL getter
  Uri get myUrl => Uri.parse('${Variables.baseUrl}/api/api-$myEndPoint');

  // Method untuk mendapatkan header (termasuk authData)
  Future<Map<String, String>> getHeaders() async {
    final authData = await AuthLocalDatasource().getAuthData();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token ?? ''}', // Safe access
    };
  }

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

  //  =====  di sini getALL dan delete akan selalu sama, tidak perlu dirubah

  // getALL / index
  Future<Either<String, HolidayResponseModel>> getHolidays() async {
    logger.i('SUKSES: $myEndPoint dipanggil');
    final headers = await getHeaders();

    return requestHandler(() => http.get(myUrl, headers: headers),
        (response) => HolidayResponseModel.fromJson(response.body));
  }

  // Delete
  Future<Either<String, String>> deleteHoliday(int id) async {
    final headers = await getHeaders();
    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL

    return requestHandler(() => http.delete(urlWithId, headers: headers),
        (response) => '$myEndPoint berhasil dihapus.');
  }

  // =================

  // Fungsi untuk membuat JSON body (Field dinamis)
  String generateBody(String name, int year, int month, DateTime date,
      bool isWeekend, int createdBy) {
    return jsonEncode({
      'name': name,
      'year': year,
      'month': month,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'isweekend': isWeekend,
      'created_by': createdBy,
    });
  }

  // add / create
  Future<Either<String, String>> addHoliday(
      String name, int year, int month, DateTime date, bool isWeekend) async {
    final headers = await getHeaders();
    final authData = await AuthLocalDatasource().getAuthData();

    // Check if authData.user is null, and handle appropriately
    final int? userId = authData.user!.id;
    if (userId == null) {
      return const Left('User ID tidak ditemukan. Harap login ulang.');
    }

    final String body =
        generateBody(name, year, month, date, isWeekend, userId);

    return requestHandler(() => http.post(myUrl, headers: headers, body: body),
        (response) => '$myEndPoint berhasil dibuat.');
  }

  // edit / update
  Future<Either<String, String>> editHoliday(int id, String name, int year,
      int month, DateTime date, bool isWeekend) async {
    final headers = await getHeaders();
    final authData = await AuthLocalDatasource().getAuthData();

    // Check if authData.user is null, and handle appropriately
    final int? userId = authData.user!.id; //authData.user?.id;
    if (userId == null) {
      return const Left('User ID tidak ditemukan. Harap login ulang.');
    }

    final String body =
        generateBody(name, year, month, date, isWeekend, userId);

    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL

    return requestHandler(
        () => http.put(urlWithId, headers: headers, body: body),
        (response) => '$myEndPoint berhasil diperbarui.');
  }
}
