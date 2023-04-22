import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin_admin/constants.dart';
import 'package:smart_dustbin_admin/provider/dusty_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenArguments {
  final String title;
  final String description;
  final String location;
  final String image;
  final GeoPoint position;
  final DocumentReference reference;

  ScreenArguments(
      this.title, this.description, this.location, this.image, this.position, this.reference);
}

class ComplaintDetails extends StatelessWidget {
  static const String id = 'complaint-details';

  const ComplaintDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dustyProvider = Provider.of<DustyProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    double lat = args.position.latitude;
    double lon = args.position.longitude;
    final String url = "https://maps.google.com/?q=$lat,$lon";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Complaint Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 2.0,
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(height: 200, color: Colors.grey),
              Positioned.fill(
                child: Image.network(
                  args.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  args.location,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(args.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            child: Container(
              margin: const EdgeInsets.all(15),
              height: 50.0,
              width: width(context) - 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Color(0xffff5f6d)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  backgroundColor: const Color(0xffff5f6d),
                ),
                onPressed: () async {
                  launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text(
                  "Go  to  Location",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            child: Container(
              margin: const EdgeInsets.only(left: 30),
              height: 50.0,
              width: width(context) - 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Color(0xffffb920)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  backgroundColor: const Color(0xffffb920),
                ),
                onPressed: () async {
                  EasyLoading.show(status: "Please Wait...");
                  dustyProvider.markAsResolved(args.reference).whenComplete(() {
                    EasyLoading.showSuccess("Marked as resolved");
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Mark as resolved",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
