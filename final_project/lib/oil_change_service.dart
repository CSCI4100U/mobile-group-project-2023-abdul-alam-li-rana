// oil_change_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'oil_change_interval.dart'; // Import the OilChangeInterval class

class OilChangeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOilChangeInterval(OilChangeInterval interval) async {
    await _firestore.collection('oilChangeIntervals')
        .doc(interval.vehicleId)
        .set({
      'vehicleId': interval.vehicleId,
      'lastOilChangeMileage': interval.lastOilChangeMileage,
      'recommendedInterval': interval.recommendedInterval,
    });
  }

  Future<List<OilChangeInterval>> getOilChangeIntervals(
      String vehicleId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('oilChangeIntervals')
        .where('vehicleId', isEqualTo: vehicleId)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return OilChangeInterval(
        vehicleId: data['vehicleId'],
        lastOilChangeMileage: data['lastOilChangeMileage'],
        recommendedInterval: data['recommendedInterval'],
      );
    }).toList();
  }
}
