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
import 'package:flutter/widgets.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';
import 'package:man_hinh_ung_dung/man_hinh_ung_dung.dart';
import 'package:man_hinh_ung_dung/xay_dung_widget_hoat_hinh.dart';

/// Widget cho luồng màn hình, xếp lớp các màn hình con.
class WidgetLuongManHinhXepLop extends WidgetCuaDieuKhienManHinh<LuongManHinh> {

  /// Kiểu `bool`. Có sử dụng hoạt hình chuyển động hay không. Mặc định là có và tuỳ theo các cấu hình hoạt hình.
  static const String kKeyThamSoChoPhepHoatHinh = "WidgetLuongXepLop_Animable";
  /// Kiểu `XayDungWidgetHieuUngChuyenDong`. Dùng để tạo animation khi thay đổi màn hình.
  /// Áp dụng cho `thamSo` trong các hàm thay đổi màn hình của LuongManHinh (ưu tiên cao hơn)
  /// cũng như `thamSoDieuKhienThayDoiManHinh` của màn hình cần thay đổi.
  /// Lưu ý: khi thêm màn hình vào luồng thì sẽ chạy hoạt hình `forward`. Khi loại bỏ màn hình thì chạy hoạt hình `backward`.
  static const String kKeyThamSoHoatHinh = "WidgetLuongXepLop_Anim";
  /// Kiểu `bool`. Áp dụng cho `thamSoDieuKhienThayDoiManHinh` của màn hình.
  /// Mặc định là `false`.
  /// Từ màn hình hiện tại trở về trước, dừng hiển thị nếu màn hình có thuộc tính này `false`.
  static const String kKeyThamSoLopTrong = "WidgetLuongXepLop_Trong";
  /// Điều khiển hoạt hình (nếu có) khi áp dụng hiệu ứng chuyển động chuyển màn hình.
  /// Được gán vào `thamSo` trong hàm `xayDungGiaoDienNguoiDung` của màn hình đích.
  /// Kiểu dữ liệu: `AnimationController`.
  static const String kKeyDieuKhienHoatHoa = "WidgetLuongXepLop_AnimController";
  /// Kiểu hiệu ứng chuyển động khi chuyển màn hình (`true` là màn hình được hiển thị, `false` là màn hình bị ẩn đi).
  /// Được gán vào `thamSo` trong hàm `xayDungGiaoDienNguoiDung` của màn hình đích.
  /// Kiểu dữ liệu: `bool`.
  static const String kKeyDieuKhienKieuChuyenDoi = "WidgetLuongXepLop_Kieu";

  /// Độ dài hoạt hình chuyển động
  final Duration doDaiHoatHinh;
  /// Cho phép chạm khi đang chuyển động hoạt hình
  final bool choPhepChamKhiChuyenDongHoatHinh;
  /// Hoạt hình mặc định
  final XayDungWidgetHieuUngChuyenDong? hoatHinh;

  const WidgetLuongManHinhXepLop({
    super.key,
    required super.dieuKhienManHinh,
    this.doDaiHoatHinh = const Duration(milliseconds: 300),
    this.choPhepChamKhiChuyenDongHoatHinh = false,
    this.hoatHinh
  });

  @override
  State<StatefulWidget> createState() => _TrangThaiWidgetLuongManHinhXepLop();

}

class _TrangThaiWidgetLuongManHinhXepLop extends TrangThaiWidgetCuaDieuKhien<WidgetLuongManHinhXepLop> with SingleTickerProviderStateMixin, TrangThaiWidgetManHinhCoHieuUng {

  bool _daKhoiTao = false;

  late AnimationController _dkChuyenDongHoatHinh;

  List<Widget> _dsMhCanHienThi = [];
  void Function()? _hoanTatCapNhat;
  Widget? _lopHoatHinh;

  void _khoiTaoDKHoatHinh() {
    _dkChuyenDongHoatHinh = AnimationController(
      duration: widget.doDaiHoatHinh,
      vsync: this
    );
  }

  @override
  void initState() {
    super.initState();
    _daKhoiTao = false;
    _khoiTaoDKHoatHinh();
  }

  @override
  void didUpdateWidget(covariant WidgetLuongManHinhXepLop oldWidget) {
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
    _dsMhCanHienThi.clear();
    _lopHoatHinh = null;

    dynamic temp = duLieuDinhKem?[LuongManHinh.kKeyThamSoDieuKhienWidgetLuongMH];
    if (temp is! ThamSoDieuKhienWidgetLuongManHinh) {
      throw("WidgetLuongManHinhTruot: Điều khiển màn hình không phải là 1 luồng");
    }
    final ThamSoDieuKhienWidgetLuongManHinh thamSoDk = temp;
    _hoanTatCapNhat = thamSoDk.hoatTatThayDoi;
    bool laThemMoi = true;
    if (thamSoDk.manHinhCu != null) {
      laThemMoi = thamSoDk.danhSachManHinh.contains(thamSoDk.manHinhCu);
      if (laThemMoi && thamSoDk.manHinhMoi != null) {
        final int sttCu = thamSoDk.danhSachManHinh.indexOf(thamSoDk.manHinhCu!);
        final int sttMoi = thamSoDk.danhSachManHinh.indexOf(thamSoDk.manHinhMoi!);
        laThemMoi = sttMoi > sttCu;
      }
    }
    bool choPhepHoatHinh = true;
    if (laThemMoi) {
      temp = thamSoDk.manHinhMoi?.manHinh.thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh];
      if (temp is bool) {
          choPhepHoatHinh = temp;
      }
    } else {
      temp = thamSoDk.manHinhCu?.manHinh.thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh];
      if (temp is bool) {
          choPhepHoatHinh = temp;
      }
    }
    temp = thamSoDk.thamSoDieuKhienThayDoiManHinh?[WidgetLuongManHinhXepLop.kKeyThamSoChoPhepHoatHinh];
    if (temp is bool) {
        choPhepHoatHinh = temp;
    }
    if (widget.doDaiHoatHinh.compareTo(Duration.zero) <= 0) {
      choPhepHoatHinh = false;
    }
    if (thamSoDk.manHinhCu == null || thamSoDk.manHinhMoi == null) {
      choPhepHoatHinh = false;
    }

    XayDungWidgetHieuUngChuyenDong? hoatHinh;
    if (choPhepHoatHinh) {
      hoatHinh = widget.hoatHinh;
      temp = (laThemMoi ? thamSoDk.manHinhMoi : thamSoDk.manHinhCu)?.manHinh.thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoHoatHinh];
      if (temp is XayDungWidgetHieuUngChuyenDong) {
          hoatHinh = temp;
      }
      temp = thamSoDk.thamSoDieuKhienThayDoiManHinh?[WidgetLuongManHinhXepLop.kKeyThamSoHoatHinh];
      if (temp is XayDungWidgetHieuUngChuyenDong) {
          hoatHinh = temp;
      }
    }
    if (hoatHinh != null) {
      final Map<String, dynamic> thamSoUI = {
        WidgetLuongManHinhXepLop.kKeyDieuKhienHoatHoa: _dkChuyenDongHoatHinh,
        WidgetLuongManHinhXepLop.kKeyDieuKhienKieuChuyenDoi: laThemMoi
      };
      if (laThemMoi) {
        _xayDungDSHienThiManHinh(context, thamSoDk.manHinhCu, thamSoDk.danhSachManHinh);
        final Container mhMoiContainer = thamSoDk.manHinhMoi!.taoContainer(context, thamSoUI);
        final Widget animWidget = hoatHinh.call(context, mhMoiContainer, _dkChuyenDongHoatHinh);
        _lopHoatHinh = animWidget;
        setState(() {});
        _dkChuyenDongHoatHinh.forward(from: _dkChuyenDongHoatHinh.lowerBound).then((value) {
          _dsMhCanHienThi.add(mhMoiContainer);
          _lopHoatHinh = null;
          trySetState();
          _hoanTatCapNhat?.call();
          _hoanTatCapNhat = null;
        });
      } else {
        _xayDungDSHienThiManHinh(context, thamSoDk.manHinhMoi, thamSoDk.danhSachManHinh);
        final Widget animWidget = hoatHinh.call(context, thamSoDk.manHinhCu!.taoContainer(context, thamSoUI), _dkChuyenDongHoatHinh);
        _lopHoatHinh = animWidget;
        setState(() {});
        _dkChuyenDongHoatHinh.reverse(from: _dkChuyenDongHoatHinh.upperBound).then((value) {
          _lopHoatHinh = null;
          trySetState();
          _hoanTatCapNhat?.call();
          _hoanTatCapNhat = null;
        });
      }
    } else {
      _xayDungDSHienThiManHinh(context, thamSoDk.manHinhMoi, thamSoDk.danhSachManHinh);
      setState(() {});
      _hoanTatCapNhat?.call();
      _hoanTatCapNhat = null;
    }
  }

  void _xayDungDSHienThiManHinh(BuildContext context, MucTrongLuongManHinh? manHinhDich, List<MucTrongLuongManHinh> dsManHinh) {
    _dsMhCanHienThi.clear();
    if (manHinhDich != null) {
      if (dsManHinh.contains(manHinhDich)) {
        final int sttHt = dsManHinh.indexOf(manHinhDich);
        List<Widget> dsMhCanHienThi = [];
        for (int stt = sttHt; sttHt >= 0; stt -= 1) {
          final MucTrongLuongManHinh mh = dsManHinh[stt];
          dsMhCanHienThi.add(mh.taoContainer(context, null));
          bool laMhTrong = false;
          final temp = mh.manHinh.thamSoDieuKhienWidgetLuong[WidgetLuongManHinhXepLop.kKeyThamSoLopTrong];
          if (temp is bool) {
            laMhTrong = temp;
          }
          if (!laMhTrong) {
            break;
          }
        }
        _dsMhCanHienThi = dsMhCanHienThi.reversed.toList();
      } else {
        _dsMhCanHienThi.add(manHinhDich.taoContainer(context, null));
      }
    } else {
      for (final mh in dsManHinh) {
        _dsMhCanHienThi.add(mh.taoContainer(context, null));
      }
    }
  }

  void _khoiTaoDSManHinh(BuildContext context) {
    List<MucTrongLuongManHinh> dsMh = widget.dieuKhienManHinh.dsManHinhThuocLuong;
    MucTrongLuongManHinh? mhHt = widget.dieuKhienManHinh.manHinhHienTaiCuaLuong;
    _dsMhCanHienThi.clear();
    if (mhHt != null) {
      _xayDungDSHienThiManHinh(context, mhHt, dsMh);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_daKhoiTao) {
      _daKhoiTao = true;
      _khoiTaoDSManHinh(context);
    }
    if (_lopHoatHinh != null) {
      return IgnorePointer(
        ignoring: !widget.choPhepChamKhiChuyenDongHoatHinh,
        child: Stack(children: [
          Stack(children: _dsMhCanHienThi),
          _lopHoatHinh!
        ])
      );
    }
    return Stack(children: _dsMhCanHienThi);
  }

}