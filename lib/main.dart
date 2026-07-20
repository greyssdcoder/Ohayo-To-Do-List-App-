import 'package:flutter/material.dart';
import 'package:ohayo/screen/homeScreen.dart';
import 'package:ohayo/theme_notifier.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.init();
  runApp( const Homescreen());
}