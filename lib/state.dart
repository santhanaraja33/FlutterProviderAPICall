import 'package:flutter/material.dart';

class CounterState extends ChangeNotifier {
  int counter = 0;

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (counter != 0) {
      counter--;
    } else {
      counter = 0;
    }

    notifyListeners();
  }
}
