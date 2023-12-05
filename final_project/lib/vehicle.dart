
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
      fuelCapacity: map['fuelCapacity'] as String? ?? '', type: '', // Initialize fuelCapacity from map.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'vin': vin, // Include VIN in the map.
      'mileage': mileage, // Include mileage in the map.
      'fuelCapacity': fuelCapacity, // Include fuelCapacity in the map.
    };
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, vin: $vin, make: $make, model: $model, year: $year, color: $color, mileage: $mileage, fuelCapacity: $fuelCapacity}';
  }
}