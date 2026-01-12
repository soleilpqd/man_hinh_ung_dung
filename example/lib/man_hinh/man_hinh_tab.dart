import 'package:example/main.dart';
import 'package:example/man_hinh/man_hinh_noi_dung.dart';
import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_truot.dart';

class DieuKhienManHinhTab extends LuongManHinhCuaToi {

  DieuKhienManHinhTab() : super(dinhDanh: DinhDanhLuongManHinh.tab) {
    final LuongManHinhCuaToi luong1 = LuongManHinhCuaToi(dinhDanh: DinhDanhLuongManHinh.luong1);
    luong1.widgetCuaManHinh = WidgetLuongManHinhTruot(dieuKhienManHinh: luong1);
    final DieuKhienManHinhNoiDung mh1 = DieuKhienManHinhNoiDung(maManHinh: 100);
    luong1.themManHinh(manHinh: mh1);
    final DieuKhienManHinhNoiDung mh2 = DieuKhienManHinhNoiDung(maManHinh: 200);
    final DieuKhienManHinh mh3 = DieuKhienManHinh();
    mh3.widgetCuaManHinh = const Center(child: Text("Nội dung cố định"));

    ganDanhSachManHinh(danhSachMoi: [luong1, mh2, mh3], thuTuManHinhHienTaiMoi: 0);
  }

  void khiNhanNutTab(int stt) {
    ganManHinhHienTai(stt: stt);
  }

  @override
  Widget xayDungGiaoDienNguoiDung(BuildContext context) {
    return _ManHinhTab(dieuKhienManHinh: this);
  }

}

class _ManHinhTab extends WidgetCuaDieuKhienManHinh<DieuKhienManHinhTab> {

  const _ManHinhTab({required super.dieuKhienManHinh});

  @override
  State<StatefulWidget> createState() => _TrangThaiManHinhTab();

}

class _TrangThaiManHinhTab extends TrangThaiWidgetCuaDieuKhien<_ManHinhTab> with TrangThaiWidgetManHinh {

  @override
  void capNhaptGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, ThamSoDieuKhienWidgetManHinh? duLieuDinhKem}) {
    setState(() {

    });
    final temp = duLieuDinhKem?[LuongManHinh.kKeyThamSoDieuKhienWidgetLuongMH];
    if (temp is ThamSoDieuKhienWidgetLuongManHinh) {
      final ThamSoDieuKhienWidgetLuongManHinh thamSo = temp;
      thamSo.hoatTatThayDoi.call();
    }
  }

  List<Widget> _xayDungCacNutTab() {
    List<Widget> ketQua = [];
    DieuKhienManHinh? mhht = widget.dieuKhienManHinh.manHinhHienTai;
    int sttHienTai = 0;
    if (mhht != null) {
      sttHienTai = widget.dieuKhienManHinh.timSoThuTuManHinhTrongLuong(mhht) ?? 0;
    }
    for (int stt = 0; stt < widget.dieuKhienManHinh.danhSachManHinh.length; stt += 1) {
      ketQua.add(Expanded(child: Container(
        color: stt == sttHienTai ? Colors.blueAccent : Colors.lightBlueAccent,
        child: TextButton(
          onPressed: () => widget.dieuKhienManHinh.khiNhanNutTab(stt),
          child: Text("Tab #$stt", style: const TextStyle(color: Colors.white))
        )
      )));
    }
    return ketQua;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: widget.dieuKhienManHinh.manHinhHienTai?.xayDungGiaoDienNguoiDung(context) ?? Container()),
      SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _xayDungCacNutTab(),
        ),
      ),
      Container(color: Colors.white, height: 50)
    ]);
  }

}
