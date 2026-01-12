import 'package:flutter/material.dart';

class DuLieuToanCuc extends ValueNotifier<bool> {

  static final DuLieuToanCuc _instance = DuLieuToanCuc._internal();

  DuLieuToanCuc._internal() : super(false);

  factory DuLieuToanCuc() => _instance;

  int _soDem = 0;
  int get soDem => _soDem;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _soDem += 1;
    notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    _soDem -= 1;
    notifyListeners();
  }

}
