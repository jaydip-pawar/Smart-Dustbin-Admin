import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin_admin/provider/dusty_provider.dart';
import 'package:smart_dustbin_admin/screens/complaints/complaint_details.dart';

class ComplaintList extends StatelessWidget {
  static const String id = 'complaint-list';

  const ComplaintList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dustyProvider = Provider.of<DustyProvider>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dustyProvider.db.collection('Complaints').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.size,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  title: Text(snapshot.data!.docs[index].get("title")),
                  subtitle: Text(snapshot.data!.docs[index].get("location")),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ComplaintDetails.id,
                      arguments: ScreenArguments(
                        snapshot.data!.docs[index].get("title"),
                        snapshot.data!.docs[index].get("description"),
                        snapshot.data!.docs[index].get("location"),
                        snapshot.data!.docs[index].get("image"),
                        snapshot.data!.docs[index].get("position"),
                        snapshot.data!.docs[index].reference,
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
