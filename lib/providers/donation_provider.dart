import 'dart:collection';

import 'package:final_proj/entities/donations.dart';
import 'package:flutter/cupertino.dart';

abstract class DonationProvider with ChangeNotifier {
  Future<void> addINTERNAL(Donation donation);

  Future<void> updateINTERNAL(Donation donation);

  Future<void> removeINTERNAL(Donation donation);

  Future<List<Donation>> getAllINTERNAL();

  Future<Donation> getByIdINTERNAL(String id);

  Future<int> getPageCount(int pageSize) async {
    List<Donation> donations = await getAllINTERNAL();
    return (donations.length / pageSize).ceil();
  }

  Future<UnmodifiableListView<Donation>> getPage(
    int pageNumber,
    int pageSize,
  ) async {
    List<Donation> donations = await getAllINTERNAL();
    int startIndex = pageNumber * pageSize;

    return UnmodifiableListView(donations.getRange(startIndex, startIndex + pageSize));
  }

  Future<void> add(Donation donation) async {
    await addINTERNAL(donation);
    notifyListeners();
  }

  Future<void> update(Donation donation) async {
    await updateINTERNAL(donation);
    notifyListeners();
  }

  Future<void> remove(Donation donation) async {
    await removeINTERNAL(donation);
    notifyListeners();
  }
}
