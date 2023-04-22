import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin_admin/provider/dusty_provider.dart';
import 'package:smart_dustbin_admin/screens/bin_list/bin_screen.dart';

class BinList extends StatelessWidget {
  static const String id = 'bin-list';
  const BinList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dustyProvider = Provider.of<DustyProvider>(context);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dustyProvider.db.collection('Dustbins').orderBy("Number").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.size,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  title: Text(snapshot.data!.docs[index].get("Name")),
                  subtitle: Text(snapshot.data!.docs[index].get("Location")),
                  trailing: Icon(
                    snapshot.data!.docs[index].get("Status") == true
                        ? CupertinoIcons.trash_fill
                        : CupertinoIcons.trash_slash_fill,
                    color: snapshot.data!.docs[index].get("Status") == true
                        ? Colors.green
                        : Colors.red,
                  ),
                  onTap: () {
                    if(snapshot.data!.docs[index].get("Status") == true) {
                      Navigator.pushNamed(
                        context,
                        BinScreen.id,
                        arguments: ScreenArguments(
                          snapshot.data!.docs[index].get("Number").toInt(),
                          snapshot.data!.docs[index].get("LocationLink"),
                          snapshot.data!.docs[index].get("Name"),
                          snapshot.data!.docs[index].get("Location"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Dustbin not installed yet!")));
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
