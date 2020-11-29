import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:archive_your_bill/model/bill.dart';


class BillNotifier with ChangeNotifier {
  List<Bill> _billList = [];
  Bill _currentBill;

  UnmodifiableListView<Bill> get billList => UnmodifiableListView(_billList);

  Bill get currentBill => _currentBill;

  set billList(List<Bill> billList) {
    _billList = billList;
    notifyListeners();
  }

  set currentBill(Bill bill) {
    _currentBill = bill;
    notifyListeners();
  }

  addBill(Bill bill) {
    _billList.insert(0, bill);
    notifyListeners();
  }

  deleteBill(Bill bill) {
    _billList.removeWhere((_bill) => _bill.id == bill.id);
    notifyListeners();
  }
}