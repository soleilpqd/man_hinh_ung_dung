import 'package:app_links/app_links.dart';
import 'package:example/man_hinh/man_hinh_noi_dung.dart';
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
    WidgetsFlutterBinding.ensureInitialized();
    luongMHGoc.widgetCuaManHinh = WidgetLuongManHinhXepLop(
      dieuKhienManHinh: luongMHGoc,
      hoatHinh: WidgetLuongManHinhXepLop.xayDungLopTruotXuong
    );
    _khoiTaoLuongManHinhGoc();
    final AppLinks appLinks = AppLinks();
    appLinks.uriLinkStream.listen(_khiMoUri);
  }

  void _khoiTaoLuongManHinhGoc() {
    final DieuKhienManHinhTab luongTab = DieuKhienManHinhTab();
    final LuongManHinhCuaToi luongChinh = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.chinh);
    luongChinh.widgetCuaManHinh = WidgetLuongManHinhTruot(dieuKhienManHinh: luongChinh, phuongHuong: PhuongHuongLuongManHinhTruot.phaiSangTrai);
    luongChinh.themManHinh(manHinh: luongTab);
    luongMHGoc.themManHinh(manHinh: luongChinh);
  }

  LuongManHinhCuaToi? _timLuongManHinhCuaToi(LuongManHinhCuaToi? mh, DinhDanhLuongManHinh dinhDanh) {
    if (mh == null) {
      return null;
    }
    for (final muc in mh.danhSachManHinh) {
      if (muc is LuongManHinhCuaToi) {
        return muc;
      }
    }
    return null;
  }

  void _khiMoUri(Uri uri) {
    /*
     URI: `mhud://vidu.com/0/1`. Trong đó:
     - `mhud`: scheme, giá trị cố định.
     - `vidu.com`: host, giá trị cố định.
     - `0`: số, giá trị 0,1,2: chỉ định luồng.
     - `1`: số: chỉ định số màn hình nội dung thêm vào luồng.
    */
    // Khởi tạo lại hệ thống luồng màn hình
    // Kết quả mong muốn: tất cả các màn hình hiện tại đều chạy qua `manHinhBiLoaiBoKhoiLuong`
    // => DuLieuToanCuc không còn chứa đối tượng theo dõi nào.
    luongMHGoc.ganDanhSachManHinh(danhSachMoi: []);
    _khoiTaoLuongManHinhGoc();
    // Phân tích path của URI:
    LuongManHinh? luong;
    if (uri.pathSegments.isNotEmpty) {
      try {
        final int path1Num = int.parse(uri.pathSegments.first);
        switch (path1Num) {
          case 0: // Luồng 1
            LuongManHinhCuaToi? luongChinh = _timLuongManHinhCuaToi(luongMHGoc, DinhDanhLuongManHinh.chinh);
            LuongManHinhCuaToi? luongTab = _timLuongManHinhCuaToi(luongChinh, DinhDanhLuongManHinh.tab);
            luong = _timLuongManHinhCuaToi(luongTab, DinhDanhLuongManHinh.luong1);
          case 1: // Luồng chính
            luong = _timLuongManHinhCuaToi(luongMHGoc, DinhDanhLuongManHinh.chinh);
          case 2: // Luồng modal
            final LuongManHinhCuaToi luongXepLop = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.lop);
            luongXepLop.widgetCuaManHinh = WidgetLuongManHinhTruot(dieuKhienManHinh: luongXepLop, phuongHuong: PhuongHuongLuongManHinhTruot.duoiLenTren);
            final DieuKhienManHinhNoiDung mh1 = DieuKhienManHinhNoiDung(maManHinh: 300);
            luongXepLop.themManHinh(manHinh: mh1);
            luongMHGoc.themManHinh(manHinh: luongXepLop);
            luong = luongXepLop;
          default:
            break;
        }
      } catch (_) {}
      if (luong != null && uri.pathSegments.length > 1) {
        try {
          final int path2Num = int.parse(uri.pathSegments[1]);
          if (path2Num > 0) {
            int maSoCuoi = 0;
            if (luong.danhSachManHinh.last is DieuKhienManHinhNoiDung) {
              final DieuKhienManHinhNoiDung mhCuoi = luong.danhSachManHinh.last as DieuKhienManHinhNoiDung;
              maSoCuoi = mhCuoi.maManHinh;
            }
            for (int idx = 0; idx < path2Num; idx += 1) {
              maSoCuoi += 1;
              final DieuKhienManHinhNoiDung mh1 = DieuKhienManHinhNoiDung(maManHinh: maSoCuoi);
              luong.themManHinh(manHinh: mh1);
            }
          }
        } catch (_) {}
      }
    }
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
        child: luongMHGoc.xayDungGiaoDienNguoiDung(context, null)
      )
    );
  }
}
