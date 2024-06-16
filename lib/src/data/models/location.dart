class Location {
  String id;
  String name;
  String? parentId;

  Location(this.id, this.name, this.parentId);

  @override
  String toString() => 'Location(id: $id, name: $name, parentId: $parentId)';

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      map['id'],
      map['name'],
      map['parentId'],
    );
  }
}