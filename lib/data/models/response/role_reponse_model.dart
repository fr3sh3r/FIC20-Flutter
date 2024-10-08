import 'dart:convert';

class RoleResponseModel {
  final String? message;
  final List<Role>? data;

  RoleResponseModel({
    this.message,
    this.data,
  });

  factory RoleResponseModel.fromJson(String str) =>
      RoleResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoleResponseModel.fromMap(Map<String, dynamic> json) =>
      RoleResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Role>.from(json["data"]!.map((x) => Role.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Role {
  final int? id;
  final int? companyId;
  final String? name;
  final String? displayName;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Role({
    this.id,
    this.companyId,
    this.name,
    this.displayName,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        displayName: json["display_name"],
        description: json["description"],
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
        "name": name,
        "display_name": displayName,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
