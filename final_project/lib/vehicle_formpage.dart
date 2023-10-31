import 'package:flutter/material.dart';

class VehicleFormPage extends StatefulWidget {

  @override
  _VehicleFormState createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleFormPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Vehicle Details'),
      ),
    );
  }
}