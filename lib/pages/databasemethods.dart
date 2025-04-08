import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:math";
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseMethods {
  Future addEmployeeDetails(Map<String, dynamic> vehicleInfoMap,
      String id) async {
    return await FirebaseFirestore.instance
        .collection("Vehicles List")
        .doc(id)
        .set(vehicleInfoMap);
  }

  Future<Stream<QuerySnapshot>> getvehicaldetails() async {
    return await FirebaseFirestore.instance.collection("Vehicles List")
        .snapshots();
  }

  Future updateVehicalDetails(String id, Map<String, dynamic>updateInfo) async {
    return await FirebaseFirestore.instance.collection("Vehicles List")
        .doc(id)
        .update(updateInfo);
  }

  int generateUniqueId(List<int> existingIds) {
    Random random = Random();
    int newId;
    do {
      newId = random.nextInt(1000000);
    }
    while (existingIds.contains(newId));
    return newId;
  }

  Future deleteVehicalDetails(String id) async {
    return await FirebaseFirestore.instance.collection("Vehicles List")
        .doc(id).delete();
  }

}
