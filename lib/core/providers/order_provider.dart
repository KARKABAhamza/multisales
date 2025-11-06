import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final dynamic firestoreService;
  OrderProvider({this.firestoreService});
  void initialize() {}
}
