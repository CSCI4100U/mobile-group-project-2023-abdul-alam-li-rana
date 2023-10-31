class Vehicles {
  String? vin;
  String? make;
  String? model;
  int? year;
  String? type;

  Vehicles({required this.vin, required this.make, required this.model, required this.year, required this.type});

  Vehicles.fromMap(Map map){
    this.vin = map['vin'];
    this.make = map['make'];
    this.model = map['model'];
    this.year = map['year'];
    this.type = map['type'];
  }

  Map<String,Object?> toMap(){
    return{
      'vin': this.vin,
      'make': this.make,
      'model': this.model,
      'year': this.year,
      'type': this.type
    };
  }

  @override
  String toString(){
    return 'Vehicle[vin: $vin, make: $make, model: $model, year: $year, type: $type';
  }
}