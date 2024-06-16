class Asset {
  String id;
  String name;
  String? parentId;
  String? locationId;
  String? sensorId;
  String? sensorType;
  String? status;
  String? gatewayId;

  Asset(this.id, this.name, {this.parentId, this.locationId, this.sensorId, this.sensorType, this.status, this.gatewayId});

  @override
  String toString() => 'Asset(id: $id, name: $name, parentId: $parentId, locationId: $locationId, sensorId: $sensorId, sensorType: $sensorType, status: $status, gatewayId: $gatewayId)';

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      map['id'],
      map['name'],
      parentId: map['parentId'],
      locationId: map['locationId'],
      sensorId: map['sensorId'],
      sensorType: map['sensorType'],
      status: map['status'],
      gatewayId: map['gatewayId'],
    );
  }
}