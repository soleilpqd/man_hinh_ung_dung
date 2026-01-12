import 'package:example/man_hinh/man_hinh_tab.dart';
import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_truot.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_xep_lop.dart';

void main() {
  runApp(MyApp());
}

/*

  Luồng màn hình:

  - Gốc: chứa các luồng con theo kiểu xếp lớp
    - Luồng chính: chứa các màn hình/luồng
      - Luồng màn hình tab: 1 luồng kiểu tab gồm 3 màn hình/luồng
        - Luồng màn hình 1: chứa các màn hình con. Các màn hình con sẽ thêm các màn hình vào luồng màn hình 1.
        - Màn hình 2: thêm các màn hình con vào luồng chính.
        - Màn hình 3: View cố định
    - Luồng xếp lớp 2: chứa các màn con.
    - Dialog (loading, ....)
 */

enum DinhDanhLuongManHinh {
  goc, chinh, tab, luong1, lop
}

class LuongManHinhCuaToi extends LuongManHinh {

  final DinhDanhLuongManHinh dinhDanh;

  LuongManHinhCuaToi({required this.dinhDanh});

  @override
  String tuMieuTa() {
    return "$this: $dinhDanh";
  }

}

class MyApp extends StatelessWidget {

  final LuongManHinhCuaToi luongMHGoc = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.goc);

  MyApp({super.key}) {
    luongMHGoc.widgetCuaManHinh = WidgetLuongManHinhXepLop(
      dieuKhienManHinh: luongMHGoc,
      hoatHinh: WidgetLuongManHinhXepLop.xayDungLopTruotXuong
    );
    final DieuKhienManHinhTab luongTab = DieuKhienManHinhTab();
    final LuongManHinhCuaToi luongChinh = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.chinh);
    luongChinh.widgetCuaManHinh = WidgetLuongManHinhTruot(dieuKhienManHinh: luongChinh, phuongHuong: PhuongHuongLuongManHinhTruot.phaiSangTrai);
    luongChinh.themManHinh(manHinh: luongTab);
    luongMHGoc.themManHinh(manHinh: luongChinh);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: Container(
        color: Colors.white,
        child: luongMHGoc.xayDungGiaoDienNguoiDung(context)
      )
    );
  }
}
