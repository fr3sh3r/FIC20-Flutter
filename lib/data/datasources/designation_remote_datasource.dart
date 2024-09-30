import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_hrm_inventory_pos_app/core/constants/variables.dart';
import 'package:flutter_hrm_inventory_pos_app/data/models/response/designation_response_model.dart';
import 'package:http/http.dart' as http;

import 'auth_local_datasource.dart';

class DesignationRemoteDatasource {
  Future<Either<String, DesignationResponseModel>> getDesignations() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-designations');
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
      return Right(DesignationResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> addDesignation(
      String name, String description) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-designations');
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
      return const Right('Designation added successfully');
    } else {
      return Left(response.body);
    }
  }

  //edit
  Future<Either<String, String>> editDesignation(
      int id, String name, String description) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-designations/$id');
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
      return const Right('Designation updated successfully');
    } else {
      return Left(response.body);
    }
  }

  //delete
  Future<Either<String, String>> deleteDesignation(int id) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-designations/$id');
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
      return const Right('Designation deleted successfully');
    } else {
      return Left(response.body);
    }
  }
}
