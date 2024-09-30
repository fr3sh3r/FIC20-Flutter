import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_hrm_inventory_pos_app/data/models/response/department_response_model.dart';
import 'package:http/http.dart' as http;

class DepartmentRemoteDatasource {
  Future<Either<String, DepartmentResponseModel>> getDepartments() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments');
    final authData = await AuthLocalDatasource().getAuthData();  //ngambil token
    

    final header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${authData.token}',
    };

    final response = await http.get(
      url,
      headers: header,         //The request is sent to the url and includes the header for authorization and content type.
    );

    if (response.statusCode == 200) {
      return Right(DepartmentResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> createDepartment(
    String name,
    String description,
  ) async {
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

    final response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 201) {
      return const Right('Department created successfully');
    } else {
      return Left(response.body);
    }
  }

  //update
  Future<Either<String, String>> updateDepartment(
    int id,
    String name,
    String description,
  ) async {
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

    final response = await http.put(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 200) {
      return const Right('Department updated successfully');
    } else {
      return Left(response.body);
    }
  }

  //delete
  Future<Either<String, String>> deleteDepartment(int id) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-departments/$id');
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
      return const Right('Department deleted successfully');
    } else {
      return Left(response.body);
    }
  }
}
