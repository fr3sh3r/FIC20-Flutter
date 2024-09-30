import 'dart:convert';

class ContohTemplateResponseModel {
  final String? message;
  final List<Designation>? data;

  ContohTemplateResponseModel({
    this.message,
    this.data,
  });

  factory ContohTemplateResponseModel.fromJson(String str) =>
      ContohTemplateResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ContohTemplateResponseModel.fromMap(Map<String, dynamic> json) =>
      ContohTemplateResponseModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Designation>.from(
                json["data"]!.map((x) => Designation.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Designation {
  final int? id;
  final int? companyId;
  final int? createdBy;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Designation({
    this.id,
    this.companyId,
    this.createdBy,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Designation.fromJson(String str) =>
      Designation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Designation.fromMap(Map<String, dynamic> json) => Designation(
        // id: json["id"],
        // companyId: json["company_id"],
        // createdBy: json["created_by"],
        // name: json["name"],
        // description: json["description"],
        // createdAt: json["created_at"] == null
        //     ? null
        //     : DateTime.parse(json["created_at"]),
        // updatedAt: json["updated_at"] == null
        //     ? null
        //     : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        // "id": id,
        // "company_id": companyId,
        // "created_by": createdBy,
        // "name": name,
        // "description": description,
        // "created_at": createdAt?.toIso8601String(),
        // "updated_at": updatedAt?.toIso8601String(),
      };
}
