class Service {
  String id;
  String vehicle;
  String serviceName;
  String carId;
  String serviceDate;
  String serviceCost;
  String serviceDescription;
  String serviceMileage;

  Service({
    this.id = ' ',
    required this.vehicle,
    required this.serviceName,
    required this.carId,
    required this.serviceDate,
    required this.serviceCost,
    required this.serviceDescription,
    required this.serviceMileage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'vehicle': vehicle,
      'serviceName': serviceName,
      'carId': carId,
      'serviceDate': serviceDate,
      'serviceCost': serviceCost,
      'serviceDescription': serviceDescription,
      'serviceMileage': serviceMileage,
    };
  }

  static Service fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      vehicle: map['vehicle'],
      serviceName: map['serviceName']!,
      carId: map['carId']!,
      serviceDate: map['serviceDate']!,
      serviceCost: map['serviceCost']!,
      serviceDescription: map['serviceDescription']!,
      serviceMileage: map['serviceMileage']!,
    );
  }
}
