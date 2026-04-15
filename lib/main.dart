import 'package:flutter/material.dart';
import 'package:mozi_v2/app.dart';
import 'package:mozi_v2/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const App());
}
