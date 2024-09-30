import 'dart:convert';

class BasicSalaryResponseModel {
  final String? message;
  final List<BasicSalary>? data;

  BasicSalaryResponseModel({
    this.message,
    this.data,
  });

  factory BasicSalaryResponseModel.fromJson(String str) =>
      BasicSalaryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BasicSalaryResponseModel.fromMap(Map<String, dynamic> json) =>
      BasicSalaryResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<BasicSalary>.from(
                json["data"]!.map((x) => BasicSalary.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class BasicSalary {
  final int? id;
  final int? companyId;
  final int? userId;
  final String? basicSalary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BasicSalary({
    this.id,
    this.companyId,
    this.userId,
    this.basicSalary,
    this.createdAt,
    this.updatedAt,
  });

  factory BasicSalary.fromJson(String str) =>
      BasicSalary.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BasicSalary.fromMap(Map<String, dynamic> json) => BasicSalary(
        id: json["id"],
        companyId: json["company_id"],
        userId: json["user_id"],
        basicSalary: json["basic_salary"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "company_id": companyId,
        "user_id": userId,
        "basic_salary": basicSalary,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
