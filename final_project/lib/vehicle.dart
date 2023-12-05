
class Vehicle {
  final String id;
  final String make;
  final String model;
  final String year;
  final String vin;
  final String color;
  final String type;
  static const List<String> vehicleTypes = ['Sedan', 'SUV', 'Truck', 'Van', 'Motorcycle'];
  final String mileage;
  final String fuelCapacity;
  final String fuelEconomy;


  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    this.vin = '',
    this.color = '',
    this.type = '',
    this.mileage = '',
    this.fuelCapacity = '',
    this.fuelEconomy = ''
  ,
  });



  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String? ?? '',
      make: map['make'] as String? ?? '',
      model: map['model'] as String? ?? '',
      year: map['year'] as String? ?? '',
      color: map['color'] as String? ?? '', // Initialize VIN from map.
      vin: map['vin'] as String? ?? '', // Initialize VIN from map.
      mileage: map['mileage'] as String? ?? '', // Initialize mileage from map.
      fuelCapacity: map['fuelCapacity'] as String? ?? '',
      fuelEconomy: map['fuelEconomy'] as String? ?? '', // Initialize fuelCapacity from map.
// Initialize fuelCapacity from map.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'vin': vin,
      'mileage': mileage,
      'fuelCapacity': fuelCapacity,
      'fuelEconomy': fuelEconomy,

    };
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, vin: $vin, make: $make, model: $model, year: $year, color: $color, mileage: $mileage, fuelCapacity: $fuelCapacity}';
  }
}