import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'databasemethods.dart';

class AddVehiclePage extends StatefulWidget {
  final String agencyName; // <-- passed from Login/SignUp

  const AddVehiclePage({Key? key, required this.agencyName}) : super(key: key);

  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class GlobalVariables {
  static String url = '';
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  List<int> existingIds = [];
  List<int> generateIds = [];
  String? selectedItem;

  final modelController = TextEditingController();
  final priceController = TextEditingController();
  final seatController = TextEditingController();
  final coolController = TextEditingController();

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadExistingIds();
  }

  Future<void> _loadExistingIds() async {
    int newId = await DatabaseMethods().generateUniqueId(existingIds);
    setState(() {
      existingIds.add(newId);
      generateIds.add(newId);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _uploadImage() async {
    var uri = Uri.parse("https://api.cloudinary.com/v1_1/dytgqxzng/image/upload");
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'nandan'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonMap = jsonDecode(responseBody);
        setState(() {
          GlobalVariables.url = jsonMap['secure_url'];
        });
      } else {
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Vehicle"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    width: 350,
                    child: Column(
                      children: [
                        _imageFile != null
                            ? Image.file(
                          _imageFile!,
                          width: 400,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                            : Text('No image selected.'),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              child: Text("Select Image"),
                            ),
                            SizedBox(width: 30),
                            ElevatedButton(
                              onPressed: _uploadImage,
                              child: Text("Upload Image"),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text("Agency: ${widget.agencyName}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(height: 10),
                        TextField(
                          controller: modelController,
                          decoration: InputDecoration(
                            hintText: 'Vehicle Name with Year',
                          ),
                        ),
                        TextField(
                          controller: priceController,
                          decoration: InputDecoration(
                            hintText: 'Price Per km',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: seatController,
                          decoration: InputDecoration(
                            hintText: 'Number of Seats',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButton<String>(
                          items: ['Ac', 'NonAc'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("$value"),
                            );
                          }).toList(),
                          hint: Text("Ac/NonAc"),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedItem = newValue;
                              coolController.text = newValue!;
                            });
                          },
                          value: selectedItem,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                child: Text('Add'),
                                onPressed: () async {
                                  final model = modelController.text.trim();
                                  final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                                  final seat = seatController.text.trim();
                                  final cooling = coolController.text.trim();
                                  final agencyName = widget.agencyName;

                                  final id = await DatabaseMethods().generateUniqueId(existingIds);

                                  await FirebaseFirestore.instance
                                      .collection('Vehicles List')
                                      .add({
                                    'url': GlobalVariables.url,
                                    'id': id,
                                    'model': model,
                                    'price': price,
                                    'seat': seat,
                                    'cooling': cooling,
                                    'agency': agencyName,
                                  });

                                  setState(() {
                                    Fluttertoast.showToast(
                                      msg: "Vehicle added successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    existingIds.add(id);
                                  });

                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
