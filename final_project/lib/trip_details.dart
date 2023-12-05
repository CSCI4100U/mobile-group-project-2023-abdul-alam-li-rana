import 'package:flutter/material.dart';
import 'vehicle.dart';

class TripDetailsWidget extends StatelessWidget {
  final double? totalDistance;
  final double? gasPrice;
  final Vehicle? vehicle;

  TripDetailsWidget({
    required this.totalDistance,
    required this.gasPrice,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    print("do we build");
    double? fuelConsumed;
    double? costOfTrip;
    print("Is vehicle referenced?");
    print(vehicle?.color);

    print(vehicle?.fuelEconomy);
    if (vehicle != null && vehicle!.fuelEconomy != null && vehicle!.fuelEconomy!.isNotEmpty) {
      double parsedFuelEconomy = double.tryParse(vehicle!.fuelEconomy!) ?? 0.0;
      fuelConsumed = calculateFuelConsumed(totalDistance, parsedFuelEconomy);
      costOfTrip = calculateCostOfTrip(fuelConsumed, gasPrice);
      print("hello");
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 16.0), // Add space between TripDetailsWidget and the map
      decoration: BoxDecoration(
        color: Colors.yellow, // Yellow background color
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Details:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0), // Add spacing between Trip Details header and content
          if (totalDistance != null && totalDistance != 0.0)
            Text('Total Distance: ${totalDistance!.toStringAsFixed(2)} Kilometers'),
          if (gasPrice != null && gasPrice != 0.0)
            Text('Gas Price \$: ${gasPrice!.toStringAsFixed(2)}'),
          if (fuelConsumed != null && fuelConsumed != 0.0)
            Text('Fuel Consumed: ${fuelConsumed.toStringAsFixed(2)} Liters'),
          if (costOfTrip != null && costOfTrip != 0.0)
            Text('Cost of Trip \$: ${costOfTrip.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  double? calculateFuelConsumed(double? totalDistance, double fuelEconomy) {
    return totalDistance != null ? (totalDistance / 100) * fuelEconomy : null;
  }

  double? calculateCostOfTrip(double? fuelConsumed, double? gasPrice) {
    return fuelConsumed != null && gasPrice != null ? fuelConsumed * gasPrice : null;
  }
}
