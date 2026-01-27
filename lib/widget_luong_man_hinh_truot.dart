/*
MIT License

Copyright © 2025 Phạm Quang Dương

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';

/// Phương hướng trượt màn hình khi thêm mới màn hình (khi loại bỏ thì ngược lại)
enum PhuongHuongLuongManHinhTruot {
  /// Trái sang phải
  traiSangPhai,
  /// Phải sang trái
  phaiSangTrai,
  // Trên xuống dưới
  trenXuongDuoi,
  /// Dưới lên trên
  duoiLenTren;
}

/// Widget cho luồng màn hình. Hỗ trợ chuyển động hoạt hình khi thay đổi màn hình: trượt màn hình cũ ra khỏi phạm vi hiển thị đồng thời trượt màn hình mới vào.
/// Chỉ hiện thị màn hình hiện tại của luồng. Tham số điều khiển chuyển động hoạt hình `kKeyThamSoHoatHoa`.
class WidgetLuongManHinhTruot extends WidgetCuaDieuKhienManHinh<LuongManHinh> {

  // -- Key tham số truyền vào cho WidgetLuongManHinhTruot

  /// Tham số điều khiển có thực hiện chuyển động hoạt hoạ khi thay đổi màn hình hay không.
  /// Sử dụng làm tham số trong các hàm thay đổi màn hình của luồng màn hình.
  /// Kiểu dữ liệu: `bool`.
  static const String kKeyThamSoHoatHoa = "WidgetLuongTruot_Anim";

  // -- Key tham số WidgetLuongManHinhTruot truyền cho màn hình hiện tại

  /// Điều khiển hoạt hình (nếu có) khi áp dụng hiệu ứng chuyển động chuyển màn hình.
  /// Được gán vào `thamSo` trong hàm `xayDungGiaoDienNguoiDung` của màn hình đích.
  /// Kiểu dữ liệu: `AnimationController`.
  static const String kKeyDieuKhienHoatHoa = "WidgetLuongTruot_AnimController";
  /// Kiểu hiệu ứng chuyển động khi chuyển màn hình (`true` là màn hình được hiển thị, `false` là màn hình bị ẩn đi).
  /// Được gán vào `thamSo` trong hàm `xayDungGiaoDienNguoiDung` của màn hình đích.
  /// Kiểu dữ liệu: `bool`.
  static const String kKeyDieuKhienKieuChuyenDoi = "WidgetLuongTruot_Kieu";

  /// Độ dài hoạt hình chuyển động
  final Duration doDaiHoatHinh;
  /// Phương hướng di chuyển (khi thêm màn hình) (khi loại bỏ màn hình thì theo chiều ngược lại)
  final PhuongHuongLuongManHinhTruot phuongHuong;
  /// Cho phép chạm khi đang chuyển động hoạt hình
  final bool choPhepChamKhiChuyenDongHoatHinh;

  const WidgetLuongManHinhTruot({
    super.key,
    required super.dieuKhienManHinh,
    this.doDaiHoatHinh = const Duration(milliseconds: 300),
    this.phuongHuong = PhuongHuongLuongManHinhTruot.traiSangPhai,
    this.choPhepChamKhiChuyenDongHoatHinh = false
  });

  @override
  State<StatefulWidget> createState() => _TrangThaiWidgetLuongManHinhTruot();

}

class _TrangThaiWidgetLuongManHinhTruot extends TrangThaiWidgetCuaDieuKhien<WidgetLuongManHinhTruot> with SingleTickerProviderStateMixin, TrangThaiWidgetManHinhCoHieuUng {

  bool _daKhoiTao = false;

  late AnimationController _dkChuyenDongHoatHinh;
  late Animation<Offset> _toaDoVaoMoi;
  late Animation<Offset> _toaDoRaMoi;
  late Animation<Offset> _toaDoVaoCu;
  late Animation<Offset> _toaDoRaCu;

  Container? _manHinhCanHienThi;
  Container? _manHinhCu;

  bool _laThemMoi = true;
  void Function()? _hoanTatCapNhat;

  void _khoiTaoDKHoatHinh() {
    _dkChuyenDongHoatHinh = AnimationController(
      duration: widget.doDaiHoatHinh,
      vsync: this
    );
    const Offset toaDoBinhThuong = Offset.zero;
    Offset toaDoMoi = Offset.zero;
    Offset toaDoCu = Offset.zero;
    switch (widget.phuongHuong) {
      case PhuongHuongLuongManHinhTruot.traiSangPhai:
        toaDoMoi = const Offset(1.0, 0);
        toaDoCu = const Offset(-1.0, 0);
      case PhuongHuongLuongManHinhTruot.phaiSangTrai:
        toaDoMoi = const Offset(-1.0, 0);
        toaDoCu = const Offset(1.0, 0);
      case PhuongHuongLuongManHinhTruot.trenXuongDuoi:
        toaDoMoi = const Offset(0, -1.0);
        toaDoCu = const Offset(0, 1.0);
      case PhuongHuongLuongManHinhTruot.duoiLenTren:
        toaDoMoi = const Offset(0, 1.0);
        toaDoCu = const Offset(0, -1.0);
    }
    _toaDoVaoMoi = Tween<Offset>(
      begin: toaDoMoi,
      end: toaDoBinhThuong
    ).animate(_dkChuyenDongHoatHinh);
    _toaDoRaMoi = Tween<Offset>(
      begin: toaDoBinhThuong,
      end: toaDoCu
    ).animate(_dkChuyenDongHoatHinh);
    _toaDoVaoCu = Tween<Offset>(
      begin: toaDoCu,
      end: toaDoBinhThuong
    ).animate(_dkChuyenDongHoatHinh);
    _toaDoRaCu = Tween<Offset>(
      begin: toaDoBinhThuong,
      end: toaDoMoi
    ).animate(_dkChuyenDongHoatHinh);
  }

  @override
  void initState() {
    super.initState();
    _daKhoiTao = false;
    _khoiTaoDKHoatHinh();
  }

  @override
  void didUpdateWidget(covariant WidgetLuongManHinhTruot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _daKhoiTao = false;
    _khoiTaoDKHoatHinh();
  }

  @override
  void hoanThanhCapNhatGiaoDienCuaManHinhNgay({required DieuKhienManHinh dieuKhienManHinh}) {
    _dkChuyenDongHoatHinh.stop(canceled: false);
  }

  @override
  void capNhatGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, ThamSoDieuKhienWidgetManHinh? duLieuDinhKem}) {
    _manHinhCu = null;
    _manHinhCanHienThi = null;
    _laThemMoi = true;

    bool hoatHinh = true;
    dynamic temp = duLieuDinhKem?[LuongManHinh.kKeyThamSoDieuKhienWidgetLuongMH];
    if (temp is! ThamSoDieuKhienWidgetLuongManHinh) {
      throw("WidgetLuongManHinhTruot: Điều khiển màn hình không phải là 1 luồng");
    }
    final ThamSoDieuKhienWidgetLuongManHinh thamSoDk = temp;
    temp = thamSoDk.thamSoDieuKhienThayDoiManHinh?[WidgetLuongManHinhTruot.kKeyThamSoHoatHoa];
    if (temp is bool) {
        hoatHinh = temp;
    }
    if (widget.doDaiHoatHinh.compareTo(Duration.zero) <= 0) {
      hoatHinh = false;
    }
    if (thamSoDk.manHinhCu == null || thamSoDk.manHinhMoi == null) {
      hoatHinh = false;
    }
    _hoanTatCapNhat = thamSoDk.hoatTatThayDoi;

    if (thamSoDk.manHinhCu != null) {
      _laThemMoi = thamSoDk.danhSachManHinh.contains(thamSoDk.manHinhCu);
      if (_laThemMoi && thamSoDk.manHinhMoi != null) {
        final int sttCu = thamSoDk.danhSachManHinh.indexOf(thamSoDk.manHinhCu!);
        final int sttMoi = thamSoDk.danhSachManHinh.indexOf(thamSoDk.manHinhMoi!);
        _laThemMoi = sttMoi > sttCu;
      }
    }

    Map<String, dynamic>? thamSoUI;
    if (hoatHinh) {
      thamSoUI = {
        WidgetLuongManHinhTruot.kKeyDieuKhienHoatHoa: _dkChuyenDongHoatHinh,
        WidgetLuongManHinhTruot.kKeyDieuKhienKieuChuyenDoi: _laThemMoi
      };
    }
    _manHinhCanHienThi = thamSoDk.manHinhMoi?.taoContainer(context, thamSoUI);
    if (hoatHinh) {
      _manHinhCu = thamSoDk.manHinhCu?.taoContainer(context, thamSoUI);
    }
    setState(() {});
    if (hoatHinh) {
      _dkChuyenDongHoatHinh.forward(from: _dkChuyenDongHoatHinh.lowerBound).then((value) {
        _manHinhCu = null;
        trySetState();
        _hoanTatCapNhat?.call();
        _hoanTatCapNhat = null;
      });
    } else {
      _hoanTatCapNhat?.call();
      _hoanTatCapNhat = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_daKhoiTao) {
      _daKhoiTao = true;
      _manHinhCanHienThi = widget.dieuKhienManHinh.manHinhHienTaiCuaLuong?.taoContainer(context, null);
      return _manHinhCanHienThi ?? Container(color: Colors.transparent);
    }
    if (_manHinhCu != null && _manHinhCanHienThi != null) {
      return IgnorePointer(
        ignoring: !widget.choPhepChamKhiChuyenDongHoatHinh,
        child: Stack(children: [
          SlideTransition(
            position: _laThemMoi ? _toaDoRaMoi : _toaDoRaCu,
            child: _manHinhCu,
          ),
          SlideTransition(
            position: _laThemMoi ? _toaDoVaoMoi : _toaDoVaoCu,
            child: _manHinhCanHienThi,
          )
        ]
      ));
    }
    return _manHinhCanHienThi ?? Container(color: widget.dieuKhienManHinh.mauNenWidgetChua ?? Colors.transparent);
  }

}
