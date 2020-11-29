import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:archive_your_bill/model/bill.dart';


class BillNotifier with ChangeNotifier {
  List<Hparameter> _billList = [];
  Hparameter _currentBill;

  UnmodifiableListView<Hparameter> get billList => UnmodifiableListView(_billList);

  Hparameter get currentBill => _currentBill;

  set billList(List<Hparameter> billList) {
    _billList = billList;
    notifyListeners();
  }

  set currentBill(Hparameter bill) {
    _currentBill = bill;
    notifyListeners();
  }

  addBill(Hparameter bill) {
    _billList.insert(0, bill);
    notifyListeners();
  }

  deleteBill(Hparameter bill) {
    _billList.removeWhere((_bill) => _bill.id == bill.id);
    notifyListeners();
  }
}