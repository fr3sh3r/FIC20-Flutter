import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Untuk menangani exception terkait koneksi
import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../models/response/leave_reponse_model.dart';

// Template untuk Tabel Lainnya
class LeaveRemoteDatasource {
  static const int timeoutDuration = 10; // Durasi timeout dalam detik
  var logger = Logger(); // Inisialisasi logger

  // Deklarasi variabel untuk endpoint
  final String myEndPoint = "leaves"; // Ganti sesuai nama endpoint

  // URL getter
  Uri get myUrl => Uri.parse('${Variables.baseUrl}/api/api-$myEndPoint');

  // Method untuk mendapatkan header (termasuk authData)
  Future<Map<String, String>> getHeaders() async {
    final authData = await AuthLocalDatasource().getAuthData();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
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
  Future<Either<String, LeaveResponseModel>> getLeave() async {
    logger.i('SUKSES: $myEndPoint dipanggil');
    final headers = await getHeaders();

    return requestHandler(() => http.get(myUrl, headers: headers),
        (response) => LeaveResponseModel.fromJson(response.body));
  }

  // Delete
  Future<Either<String, String>> deleteLeave(int id) async {
    final headers = await getHeaders();
    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL

    return requestHandler(() => http.delete(urlWithId, headers: headers),
        (response) => '$myEndPoint berhasil dihapus.');
  }

// =================

  //           $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
  //           $table->foreignId('leave_type_id')->constrained('leave_types')->onDelete('cascade');
  //           $table->foreignId('company_id')->constrained('companies')->onDelete('cascade');
  //           $table->date('start_date');
  //           $table->date('end_date')->nullable();
  //           $table->integer('total_days')->default(1);
  //           $table->boolean('is_half_day')->default(0);
  //           $table->text('reason')->nullable();
  //           $table->boolean('is_paid')->default(1);
  //           $table->string('status')->default('pending');

  // Fungsi untuk membuat JSON body (Field dinamis)
  String generateBody(
      int intUserNa,
      int intLeaveTypeNa,
      int intCompanyNa,
      DateTime startDate,
      DateTime? endDate,
      int intTotalDays,
      bool isHalfDay,
      String txtReason,
      bool isPaid,
      String statusna) {
    return jsonEncode({
      'user_id': intUserNa, // Ganti field1 sesuai nama field, strField1 biarin
      'leave_type_id':
          intLeaveTypeNa, // Ganti field2 sesuai nama field, strField2 biarin
      'company_id': intCompanyNa,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      if (endDate != null)
        'end_date': DateFormat('yyyy-MM-dd')
            .format(endDate), // endDate hanya ditambahkan jika tidak null

      'total_days': intTotalDays,
      'is_half_day': isHalfDay,
      'reason': txtReason,
      'is_paid': isPaid,
      'status': statusna,
    });
  }

  // add / create
  Future<Either<String, String>> addLeave(
      int intUserNa,
      int intLeaveTypeNa,
      int intCompanyNa,
      DateTime startDate,
      DateTime endDate,
      int intTotalDays,
      bool isHalfDay,
      String txtReason,
      bool isPaid,
      String statusna) async {
    final headers = await getHeaders();
    final String body = generateBody(
        intUserNa,
        intLeaveTypeNa,
        intCompanyNa,
        startDate,
        endDate,
        intTotalDays,
        isHalfDay,
        txtReason,
        isPaid,
        statusna);

    return requestHandler(() => http.post(myUrl, headers: headers, body: body),
        (response) => '$myEndPoint berhasil dibuat.');
  }

  // edit / update
  Future<Either<String, String>> editLeave(
      int id,
      int intUserNa,
      int intLeaveTypeNa,
      int intCompanyNa,
      DateTime startDate,
      DateTime endDate,
      int intTotalDays,
      bool isHalfDay,
      String txtReason,
      bool isPaid,
      String statusna) async {
    final headers = await getHeaders();
    final String body = generateBody(
        intUserNa,
        intLeaveTypeNa,
        intCompanyNa,
        startDate,
        endDate,
        intTotalDays,
        isHalfDay,
        txtReason,
        isPaid,
        statusna);
    final urlWithId =
        Uri.parse('${myUrl.toString()}/$id'); // Tambahkan ID ke URL

    return requestHandler(
        () => http.put(urlWithId, headers: headers, body: body),
        (response) => '$myEndPoint berhasil diperbarui.');
  }
}
