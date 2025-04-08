import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VehicleListByAgencyPage extends StatefulWidget {
  final String agencyName; // This line is crucial!

  const VehicleListByAgencyPage({Key? key, required this.agencyName}) : super(key: key);

  @override
  State<VehicleListByAgencyPage> createState() => _VehicleListByAgencyPageState();
}

class _VehicleListByAgencyPageState extends State<VehicleListByAgencyPage> {
  final DatabaseReference _vehicleRef = FirebaseDatabase.instance.ref().child('Vehicles List');
  final DatabaseReference _agencyRef = FirebaseDatabase.instance.ref().child('agencies');

  List<Map<dynamic, dynamic>> filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    loadFilteredVehicles();
  }

  Future<void> loadFilteredVehicles() async {
    try {
      // Get list of agency names from "Agencies"
      final agencySnapshot = await _agencyRef.once();
      final agencyData = agencySnapshot.snapshot.value as Map?;
      final List<String> validAgencyNames = [];

      if (agencyData != null) {
        agencyData.forEach((key, value) {
          final agencyMap = Map<String, dynamic>.from(value);
          final name = agencyMap['name']?.toString().toLowerCase();
          if (name != null) {
            validAgencyNames.add(name);
          }
        });
      }

      // Fetch vehicles from "Vehicles List"
      final vehicleSnapshot = await _vehicleRef.once();
      final vehicleData = vehicleSnapshot.snapshot.value as Map?;
      final List<Map<String, dynamic>> allVehicles = [];

      if (vehicleData != null) {
        vehicleData.forEach((key, value) {
          final vehicleMap = Map<String, dynamic>.from(value);
          final agencyName = vehicleMap['agency']?.toString().toLowerCase();
          if (agencyName != null && validAgencyNames.contains(agencyName)) {
            allVehicles.add(vehicleMap);
          }
        });
      }

      setState(() {
        filteredVehicles = allVehicles;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Widget buildVehicleCard(Map vehicle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.96,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0.0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle['model'] ?? 'Vehicle',
                          style: const TextStyle(
                            fontFamily: 'Inter Tight',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Rating: N/A',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    ClipOval(
                      child: Image.network(
                        vehicle['url']?.isNotEmpty == true
                            ? vehicle['url']
                            : 'https://via.placeholder.com/150',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${vehicle['seat'] ?? 'N/A'} seats available\n'
                            'With ${vehicle['cooling'] ?? 'N/A'}\n'
                            'Price per km: ${vehicle['price'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agencyName), // ✅ This is the fix
        centerTitle: true,
      ),
      body: filteredVehicles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: filteredVehicles.map(buildVehicleCard).toList(),
        ),
      ),
    );
  }
}
