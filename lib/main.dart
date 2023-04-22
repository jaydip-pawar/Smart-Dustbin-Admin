import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin_admin/constants.dart';
import 'package:smart_dustbin_admin/provider/authentication_provider.dart';
import 'package:smart_dustbin_admin/provider/dusty_provider.dart';
import 'package:smart_dustbin_admin/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DustyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: null,
      macOS: null,
      linux: null,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
        switch(notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
    );

    Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream =
    FirebaseFirestore.instance.collection("Notification").snapshots();
    notificationStream.listen((event) {
      if(event.docs.isEmpty) return;
      showNotifications(event.docs.first);
    });
  }

  void showNotifications(QueryDocumentSnapshot<Map<String, dynamic>> event) {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('001', "LocalNotification", channelDescription: 'To send local notification');

    const NotificationDetails details = NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(01, event.get('title'), event.get('Description'), details);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Dusty',
      initialRoute: SplashScreen.id,
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}