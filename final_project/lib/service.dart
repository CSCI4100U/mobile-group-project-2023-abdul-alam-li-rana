class Service {
  String vehicle;
  String serviceName;
  String carId;
  String serviceDate; // Store date as a string
  String serviceCost; // Store cost as a string
  String serviceDescription;
  String serviceMileage;

  Service({
    required this.vehicle,
    required this.serviceName,
    required this.carId,
    required this.serviceDate,
    required this.serviceCost,
    required this.serviceDescription,
    required this.serviceMileage,
  });

  Map<String, String> toMap() {
    return {
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