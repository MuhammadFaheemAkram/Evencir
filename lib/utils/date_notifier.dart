import 'package:flutter/foundation.dart';

class DateNotifier extends ChangeNotifier {
  DateNotifier({DateTime? initialDate})
    : _selectedDate = initialDate ?? DateTime.now();

  DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    if (_selectedDate == date) return;
    _selectedDate = date;
    notifyListeners();
  }
}
