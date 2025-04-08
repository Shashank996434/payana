import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'addvehical.dart';

class VehicleListScreen extends StatefulWidget {
  final String agencyName;

  const VehicleListScreen({super.key, required this.agencyName});

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  final modelController = TextEditingController();
  final priceController = TextEditingController();
  final seatController = TextEditingController();
  final coolController = TextEditingController();
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref().child("Vehicles List");

  Map<dynamic, dynamic> vehicles = {};

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  void fetchVehicles() async {
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.removeWhere((key, value) => value['agency'] != widget.agencyName); // ✅ FIXED HERE
        setState(() {
          vehicles = data;
        });
      } else {
        setState(() {
          vehicles = {};
        });
      }
    });
  }

  void deleteVehicle(String key) async {
    await dbRef.child(key).remove();
  }

  void updateVehicle(String key) async {
    await dbRef.child(key).update({
      'model': modelController.text,
      'price': priceController.text,
      'seat': seatController.text,
      'cooling': coolController.text,
      'agency': widget.agencyName, // ✅ Also update to use "agency"
    });
    Navigator.pop(context);
  }

  void showEditDialog(String key, Map vehicle) async {
    modelController.text = vehicle['model'];
    priceController.text = vehicle['price'].toString();
    seatController.text = vehicle['seat'];
    coolController.text = vehicle['cooling'];

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.cancel),
                ),
                SizedBox(width: 10),
                Text('Edit Details')
              ],
            ),
            TextField(
              controller: modelController,
              decoration: InputDecoration(hintText: 'Model with year'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(hintText: 'Price Per km'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: seatController,
              decoration: InputDecoration(hintText: 'No of seats'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: coolController.text.isNotEmpty ? coolController.text : null,
              items: ['Ac', 'NonAc'].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  coolController.text = value!;
                });
              },
              hint: Text("Cooling Type"),
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () => updateVehicle(key),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Manager'),
        backgroundColor: Color(0xFF42A5F5),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVehiclePage(agencyName: widget.agencyName),
                ),
              );
              fetchVehicles(); // 🔄 Refresh list after return
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: vehicles.isEmpty
            ? Center(child: Text('No vehicles found.'))
            : ListView(
          children: vehicles.entries.map((entry) {
            final key = entry.key;
            final vehicle = entry.value;
            return Card(
              elevation: 5,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vehicle["url"] != null
                        ? Image.network(vehicle["url"], height: 100, fit: BoxFit.cover)
                        : Container(),
                    Row(
                      children: [
                        Text('Model: ${vehicle['model']}'),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.amber),
                          onPressed: () => showEditDialog(key, vehicle),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteVehicle(key),
                        ),
                      ],
                    ),
                    Text('Seat: ${vehicle['seat']}'),
                    Text('Price: ₹${vehicle['price']}'),
                    Text('Cooling: ${vehicle['cooling']}'),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
