import 'package:flutter/material.dart';

class ThanhDieuHuong extends StatelessWidget {

  /// Tiêu đề
  final Widget tieuDe;
  /// Nút trái
  final Widget? nutTrai;
  /// Nút phải
  final Widget? nutPhai;
  /// Phần chính bên dưới Navigation Bar
  final Widget noiDung;

  const ThanhDieuHuong({super.key, required this.tieuDe, this.nutTrai, this.nutPhai, required this.noiDung});

  @override
  Widget build(BuildContext context) {
    Widget? nTrai = nutTrai;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: tieuDe,
          actions: nutPhai != null ? [nutPhai!] : null,
          leading: nTrai
        ),
        body: noiDung
      );
  }

}
