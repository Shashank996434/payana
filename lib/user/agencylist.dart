import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'agency_vehical_list.dart';
import 'menuprofile.dart';

class Details09ReviWidget extends StatefulWidget {
  final String? agencyName; // Nullable so it's optional on first load

  const Details09ReviWidget({super.key, this.agencyName});

  static String routeName = 'Details09Revi';
  static String routePath = '/details09Revi';

  @override
  State<Details09ReviWidget> createState() => _Details09ReviWidgetState();
}

class _Details09ReviWidgetState extends State<Details09ReviWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PAYANA',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile05Widget()),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('agencies').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No agencies found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                final agencyName = data['name'] ?? 'No Name';
                final description = data['description'] ?? 'No Description';
                final image = data['image'] ?? 'assets/images/placeholder.jpg';
                final rating = (data['rating'] ?? 5).toDouble();

                return GestureDetector(
                  onTap: () {
                    // 👇 This is where we pass agencyName and navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleListByAgencyPage (agencyName: agencyName),
                      ),
                    );
                  },
                  child: _buildTravelCard(agencyName, description, image, rating),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTravelCard(String title, String description, String imagePath, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2))],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 24,
                    ),
                    SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              SizedBox(width: 12),
              ClipOval(
                child: Image.network(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


