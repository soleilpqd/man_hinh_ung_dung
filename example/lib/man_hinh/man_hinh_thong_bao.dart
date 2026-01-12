import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/widget_luong_man_hinh_xep_lop.dart';

class DieuKhienManHinhThongBao extends DieuKhienManHinh {

  final String noiDung;
  final void Function()? hanhDong;

  DieuKhienManHinhThongBao({required this.noiDung, this.hanhDong}) {
    widgetCuaManHinh = _ManHinhThongBao(dieuKhienManHinh: this);
    thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoLopTrong] = true;
    thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh] = false; // Tự xây dựng hoạt hình
  }

  void _khiNhanOK() {
    khiXong(){
      luongManHinh?.loaiManHinh(manHinh: this);
      hanhDong?.call();
    }
    trangThaiWidgetManHinh?.capNhaptGiaoDienCuaManHinh(dieuKhienManHinh: this, duLieuDinhKem: {"xong": khiXong});
  }

}

class _ManHinhThongBao extends WidgetCuaDieuKhienManHinh<DieuKhienManHinhThongBao> {

  const _ManHinhThongBao({required super.dieuKhienManHinh});

  @override
  State<StatefulWidget> createState() => _TrangThaiManHinhThongBao();

}

class _TrangThaiManHinhThongBao extends TrangThaiWidgetCuaDieuKhien<_ManHinhThongBao> with SingleTickerProviderStateMixin {

  late AnimationController _dkHoatHinh;

  @override
  void initState() {
    super.initState();
    _dkHoatHinh = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this
    );
    _dkHoatHinh.forward();
  }

  @override
  void capNhaptGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, ThamSoDieuKhienWidgetManHinh? duLieuDinhKem}) {
    final temp = duLieuDinhKem?["xong"];
    if (temp is void Function()) {
      void Function() xong = temp;
      _dkHoatHinh.reverse(from: _dkHoatHinh.upperBound).then((value) => xong.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget lopHoatHinh = WidgetLuongManHinhXepLop.xayDungLopThuPhong(
      context,
      Container(
        color: Colors.white.withAlpha(0),
        child: SizedBox(
          width: 300,
          height: 200,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Text(widget.dieuKhienManHinh.noiDung, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
                const Spacer(),
                TextButton(onPressed: widget.dieuKhienManHinh._khiNhanOK, child: const Text("OK"))
            ]),
          ),
        )
      ),
      _dkHoatHinh
    );
    return WidgetLuongManHinhXepLop.xayDungLopDoMo(
      context,
      Container(
        color: Colors.black.withAlpha(128),
        child: Center(child: lopHoatHinh),
      ),
      _dkHoatHinh
    );
  }

}
