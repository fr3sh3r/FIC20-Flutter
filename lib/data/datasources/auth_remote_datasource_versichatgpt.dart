import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../core/constants/variables.dart';
import '../models/response/auth_response_model.dart';
import 'auth_local_datasource.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final logger = Logger();

    try {
      final url = Uri.parse('${Variables.baseUrl}/api/login');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final body = {
        'email': email,
        'password': password,
      };

      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return Right(AuthResponseModel.fromJson(response.body));
      } else {
        final errorMessage = response.body;
        logger.e('Login failed with status code: ${response.statusCode}');
        logger.e('Error message: $errorMessage');
        return Left(errorMessage);
      }
    } on SocketException catch (e) {
      logger.e('Network error during login: $e');
      return const Left('Network error');
    } on HttpException catch (e) {
      logger.e('HTTP error during login: $e');
      return const Left('HTTP error');
    } on FormatException catch (e) {
      logger.e('JSON parsing error during login: $e');
      return const Left('Invalid response format');
    } catch (e) {
      logger.e('Unexpected error during login: $e');
      return const Left('Unexpected error');
    }
  }

  Future<Either<String, String>> logout() async {
    final logger = Logger();

    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final url = Uri.parse('${Variables.baseUrl}/api/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return const Right('Logout success');
      } else {
        final errorMessage = response.body;
        logger.e('Logout failed with status code: ${response.statusCode}');
        logger.e('Error message: $errorMessage');
        return Left(errorMessage);
      }
    } on SocketException catch (e) {
      logger.e('Network error during logout: $e');
      return const Left('Network error');
    } on HttpException catch (e) {
      logger.e('HTTP error during logout: $e');
      return const Left('HTTP error');
    } on FormatException catch (e) {
      logger.e('JSON parsing error during logout: $e');
      return const Left('Invalid response format');
    } catch (e) {
      logger.e('Unexpected error during logout: $e');
      return const Left('Unexpected error');
    }
  }
}
