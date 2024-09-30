import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../models/response/shift_response_model.dart';
import 'auth_local_datasource.dart';

class ShiftRemoteDatasource {
  //get all
  Future<Either<String, ShiftResponseModel>> getShifts() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-shifts');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      return Right(ShiftResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  //add name, clockintime, clockouttime
  Future<Either<String, String>> addShift(String name, String clockInTime,
      String clockOutTime, int lateMarkAfter, bool isSelfClocking) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-shifts');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final String body = jsonEncode({
      'name': name,
      'clock_in_time': clockInTime,
      'clock_out_time': clockOutTime,
      'late_mark_after': lateMarkAfter, // Menambahkan field baru
      'is_self_clocking': isSelfClocking, // Menambahkan field baru
    });

    final response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 201) {
      return const Right('Shift added successfully');
    } else {
      return Left(response.body);
    }
  }

  //edit
  Future<Either<String, String>> editShift({
      required int id,
      required String name,
      required String clockInTime,
      required String clockOutTime,
      required int lateMarkAfter,
      required bool isSelfClocking}) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-shifts/$id');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final String body = jsonEncode({
      'name': name,
      'clock_in_time': clockInTime,
      'clock_out_time': clockOutTime,
      'late_mark_after': lateMarkAfter, // Menambahkan field baru
      'is_self_clocking': isSelfClocking
    });

    final response = await http.put(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 200) {
      return const Right('Shift updated successfully');
    } else {
      return Left(response.body);
    }
  }

  //delete
  Future<Either<String, String>> deleteShift(int id) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-shifts/$id');
    final authData = await AuthLocalDatasource().getAuthData();
    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final response = await http.delete(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      return const Right('Shift deleted successfully');
    } else {
      return Left(response.body);
    }
  }
}
