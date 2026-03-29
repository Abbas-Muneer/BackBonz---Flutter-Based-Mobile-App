import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? bootstrapError;

  if (!DefaultFirebaseOptions.isConfigured) {
    bootstrapError = DefaultFirebaseOptions.setupMessage;
  } else {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      bootstrapError =
          'Firebase could not be initialized. Run FlutterFire configuration '
          'and make sure the generated options match your Firebase project.';
    }
  }

  runApp(BackBonzApp(bootstrapError: bootstrapError));
}
