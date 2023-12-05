class CarService {
  String serviceName;
  String carId;
  String serviceDate; // Store date as a string
  String serviceCost; // Store cost as a string
  String serviceDescription;

  CarService({
    required this.serviceName,
    required this.carId,
    required this.serviceDate,
    required this.serviceCost,
    required this.serviceDescription,
  });

  Map<String, String> toMap() {
    return {
      'serviceName': serviceName,
      'carId': carId,
      'serviceDate': serviceDate,
      'serviceCost': serviceCost,
      'serviceDescription': serviceDescription,
    };
  }

  static CarService fromMap(Map<String, String> map) {
    return CarService(
      serviceName: map['serviceName']!,
      carId: map['carId']!,
      serviceDate: map['serviceDate']!,
      serviceCost: map['serviceCost']!,
      serviceDescription: map['serviceDescription']!,
    );
  }
}