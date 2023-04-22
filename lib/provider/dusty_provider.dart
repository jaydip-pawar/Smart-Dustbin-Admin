import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DustyProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();
  int status = 0;

  String location = '';
  late GeoPoint geoPoint;

  setStatus(int status) {
    this.status = status;
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    EasyLoading.show(status: "Image uploading...");
    late String downloadURL;
    final Reference imageRef =
        storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.png');

    try {
      await imageRef.putFile(imageFile);
      downloadURL = await imageRef.getDownloadURL();
    } catch (e) {
      EasyLoading.showError("Image upload failed");
    }
    EasyLoading.dismiss();
    return downloadURL;
  }

  registerComplaint(
    BuildContext context,
    File image,
    String title,
    String description,
  ) async {
    EasyLoading.show(status: "please wait...");
    if (!await _getCurrentLocation(context)) return;
    final url = await uploadImage(image);
    EasyLoading.show(status: "please wait...");
    final DocumentReference documentRef = db.collection('Complaints').doc();

    await documentRef.set({
      'title': title,
      'description': description,
      'image': url,
      'location': location,
      'position': geoPoint,
    });
    EasyLoading.showSuccess("Complaint registered");
    Navigator.pop(context);
  }

  Future<bool> _getCurrentLocation(BuildContext context) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!await _checkLocationPermission(context)) {
      return false;
    }

    if (!isLocationEnabled) {
      _showLocationSettingsDialog(context);
      return false;
    }
    EasyLoading.show(status: "fetching location...");
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      location =
          "${placemarks[0].name!}, ${placemarks[0].subLocality!}, ${placemarks[0].locality!}, ${placemarks[0].administrativeArea!}";

      geoPoint = GeoPoint(position.latitude, position.longitude);

    } catch (e) {
      print(e);
    }
    return true;
  }

  Future<bool> _checkLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Fluttertoast.showToast(
            msg: 'Location permissions are denied (actual value: $permission).',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return false;
      }
    }

    return true;
  }

  Future<void> markAsResolved(DocumentReference reference) async {
    await db.runTransaction((Transaction myTransaction) async {
      myTransaction.delete(reference);
    });
  }

  void _showLocationSettingsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enable Location'),
            content: Text(
                'Your location is turned off. Please enable your location to use this app.'),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('ENABLE'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openLocationSettings();
                },
              ),
            ],
          );
        });
  }
}
