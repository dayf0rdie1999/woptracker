import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/loading/loading.dart';
import 'package:woptracker/ui/ui_wrapper.dart';

final userProvider = StreamProvider((_) => AuthService(auth: FirebaseAuth.instance).user);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MaterialApp(
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          home: MyApp(),
        )
      )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("Something Went Horribly Wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthWrapper();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}


