import 'dart:convert';

class Company {
  final String id;
  final String name;

  Company({required this.id, required this.name});

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'],
    );
  }

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source));
}