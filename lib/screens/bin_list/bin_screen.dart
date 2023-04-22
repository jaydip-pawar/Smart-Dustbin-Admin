import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smart_dustbin_admin/constants.dart';
import 'package:smart_dustbin_admin/model/custome_dustbin.dart';
import 'package:smart_dustbin_admin/provider/dusty_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenArguments {
  final int number;
  final String url;
  final String name;
  final String location;

  ScreenArguments(this.number, this.url, this.name, this.location);
}

class DustbinClipper extends CustomClipper<Path> {
  @override
  Rect getApproximateClipRect(Size size) =>
      Rect.fromLTRB(0, 0, size.width, size.height);

  @override
  Path getClip(Size size) => CustomDustbin().getPath(size);

  @override
  bool shouldReclip(DustbinClipper _) => false;
}

class BinScreen extends StatefulWidget {
  static const String id = 'bin-screen';

  const BinScreen({Key? key}) : super(key: key);

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen> {
  ValueNotifier<int> dustbinLevel = ValueNotifier<int>(0);

  void _updateUI(BuildContext context) {
    final dustyProvider = Provider.of<DustyProvider>(context, listen: false);
    dustyProvider.setStatus(dustbinLevel.value);
  }

  @override
  void didChangeDependencies() {
    dustbinLevel.addListener(() => _updateUI(context));

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String path = "Dustbin${args.number}";
    final database = FirebaseDatabase.instance.ref().child(path);
    database.onValue.listen((event) {
      dustbinLevel.value = (event.snapshot.value as Map)['level'].toInt();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final dustyProvider = Provider.of<DustyProvider>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          args.name,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 2.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Center(
            child: SizedBox(
              height: height(context) * 0.5,
              width: width(context) * 0.6,
              child: ClipPath(
                clipBehavior: Clip.antiAlias,
                clipper: DustbinClipper(),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                            flex: (100 - dustbinLevel.value).toInt(),
                            child: Container(color: Colors.blue[100])),
                        Expanded(
                            flex: dustbinLevel.value,
                            child: Container(color: Colors.blue)),
                      ],
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: CircularPercentIndicator(
                          radius: width(context) * 0.18,
                          lineWidth: 10.0,
                          animation: true,
                          percent: dustbinLevel.value.toDouble() / 100,
                          center: Text(
                            "${dustbinLevel.value}%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: dustbinLevel.value > 75
                              ? Colors.red
                              : dustbinLevel.value > 50
                                  ? Colors.yellow
                                  : dustbinLevel.value >= 0
                                      ? Colors.green
                                      : Colors.green,
                        ))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: Color(0xffff5f6d)),
                ),
                padding: const EdgeInsets.all(10.0),
                backgroundColor: const Color(0xffff5f6d),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 15),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Dustbin Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 22),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Name: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.name,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          "Number: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.number.toString(),
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          "Location: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.location,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          "Status: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          "${dustyProvider.status} %",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Close")),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                "Show Dustbin details",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 50.0,
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
                    Uri.parse(args.url),
                    mode: LaunchMode.externalApplication,
                  );
                },
              child: const Text(
                "Go To Location",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
