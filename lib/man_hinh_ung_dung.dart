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

library man_hinh_ung_dung;

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:man_hinh_ung_dung/luong_man_hinh.dart';

/// Trạng thái widget của màn hình
mixin TrangThaiWidgetManHinh {
  /// Nạp lại
  /// - [dieuKhienManHinh]: điều khiển màn hình yêu cầu nạp lại giao diện.
  /// - [duLieuDinhKem]: dữ liệu đính kèm (tuỳ ý)
  void capNhatGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, ThamSoDieuKhienWidgetManHinh? duLieuDinhKem}) {
    throw Exception("Cần khai báo ở class kế thừa (không cần gọi super)");
  }

  /// Trạng thái hiện tại đã bị thay thế bằng 1 trạng thái khác
  void daBiThayThe() {

  }

}

mixin ThongTinLapTrinh {
  /// Tự miêu tả (dùng trong `print`)
  String tuMieuTa() => "$this";
}

/// Class cơ sở/mẫu cho widget của Điều khiển màn hình
abstract class WidgetCuaDieuKhienManHinh<T extends DieuKhienManHinh> extends StatefulWidget {

  final T dieuKhienManHinh;

  const WidgetCuaDieuKhienManHinh({super.key, required this.dieuKhienManHinh});

}

abstract class TrangThaiWidgetCuaDieuKhien<T extends WidgetCuaDieuKhienManHinh > extends State<T> with TrangThaiWidgetManHinh {

  @override
  void initState() {
    super.initState();
    widget.dieuKhienManHinh.trangThaiWidgetManHinh = this;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dieuKhienManHinh.trangThaiWidgetManHinh == this) {
      oldWidget.dieuKhienManHinh.trangThaiWidgetManHinh = null;
    }
    widget.dieuKhienManHinh.trangThaiWidgetManHinh = this;
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.dieuKhienManHinh.trangThaiWidgetManHinh == this) {
      widget.dieuKhienManHinh.trangThaiWidgetManHinh = null;
    }
  }

}

/// Điều khiển màn hình
class DieuKhienManHinh with ThongTinLapTrinh {

  /// Widget của điều khiển màn hình (mặc định trả lại trong hàm `xayDungGiaoDienNguoiDung`)
  Widget? widgetCuaManHinh;

  /// Luồng màn hình chứa màn hình hiện tại
  /// Ghi chú: không tự gán giá trị
  LuongManHinh? _luongManHinh;

  /// Màu nền cho Container chứa widget của màn hình này (mặc định là trắng trong suốt)
  Color? mauNenWidgetChua;

  LuongManHinh? get luongManHinh => _luongManHinh;
  set luongManHinh(LuongManHinh? luongMoi) {
    if (_luongManHinh != null && luongMoi != null) {
      throw Exception("${tuMieuTa()} đã thuộc 1 luồng khác. Không gán trực tiếp giá trị của thuộc tính `luongManHinh` (thay vào đó sử dụng các hàm thêm và loại bỏ màn hình của class `LuongManHinh`).");
    }
    _luongManHinh = luongMoi;
  }

  /// Trạng thái (State) của Widget của Màn hình (để cập nhật lại giao diện)
  TrangThaiWidgetManHinh? _trangThaiWidgetManHinh;
  TrangThaiWidgetManHinh? get trangThaiWidgetManHinh => _trangThaiWidgetManHinh;
  set trangThaiWidgetManHinh(TrangThaiWidgetManHinh? trangThaiMoi) {
    print("DEBUG: this=${tuMieuTa()}; cu=$_trangThaiWidgetManHinh; moi=$trangThaiMoi");
    if (_trangThaiWidgetManHinh != trangThaiMoi) {
      _trangThaiWidgetManHinh?.daBiThayThe();
      _trangThaiWidgetManHinh = trangThaiMoi;
    }
  }
  /// Tham số điều khiển gán cho Widget của luồng màn hình chứa màn hình hiện tại
  ThamSoDieuKhienWidgetManHinh thamSoDieuKhienWidgetLuong = {};

  /// Màn hình được thêm vào luồng màn hình
  void manHinhDuocThemVaoLuong() {}

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) được thêm vào 1 luồng, luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhDuocThemVaoLuong(LuongManHinh luong) {}

  /// Màn hình bị loại bỏ khỏi luồng màn hình
  /// Mặc định xoá bỏ widgetManHinh và trangThaiWidgetManHinh.
  void manHinhBiLoaiBoKhoiLuong() {
    trangThaiWidgetManHinh = null;
  }

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) bị loại khỏi 1 luồng, luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhBiLoaiKhoiLuong(LuongManHinh luong) {}

  /// Màn hình sẽ được chuyển thành màn hình chính của luồng (trước khi cập nhật lại UI)
  void manHinhSeThanhManHinhChinhTrongLuong() {}

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) sẽ được chuyển thành màn hình chính của luồng,
  /// luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhSeThanhManHinhChinhTrongLuong(LuongManHinh luong) {}

  /// Màn hình đã được chuyển thành màn hình chính của luồng (sau khi cập nhật lại UI)
  void manHinhDaThanhManHinhChinhTrongLuong() {}

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) đã thành màn hình chính của luồng,
  /// luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhDaThanhManHinhChinhTrongLuong(LuongManHinh luong) {}

  /// Màn hình sẽ bị thôi làm màn hình chính của luồng (trước khi cập nhật lại UI)
  void manHinhSeThoiLamManHinhChinhTrongLuong() {}

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) sẽ thôi làm màn hình chính của luồng,
  /// luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhSeThoiLamManHinhChinhTrongLuong(LuongManHinh luong) {}

  /// Màn hình đã bị thôi làm màn hình chính của luồng (sau khi cập nhật lại UI)
  void manHinhDaThoiLamManHinhChinhTrongLuong() {}

  /// Khi luồng chứa màn hình này (hoặc luồng chứa cấp cao hơn) đã thôi làm màn hình chính của luồng,
  /// luồng chứa sẽ truyền sự kiện xuống cho màn hình/luồng con
  /// - [luong]: luồng màn hình xảy ra sự kiện (có thể là luồng chứa màn hình hiện tại hoặc luồng cao hơn)
  void luongManHinhDaThoiLamManHinhChinhTrongLuong(LuongManHinh luong) {}

  /// Kiểm tra đệ quy xem màn hình hiện tại có là màn hình chính trong luồng và luồng chứa cũng là màn hình chính.
  /// Trả lại null nếu màn hình hiện tại ko thuộc luồng nào.
  bool? laManHinhChinhTrongLuong() {
    if (luongManHinh != null) {
      bool ketQua = luongManHinh!.manHinhHienTai == this;
      bool? ketQuaLuong = luongManHinh!.laManHinhChinhTrongLuong();
      if (ketQuaLuong != null) {
        return ketQua && ketQuaLuong;
      }
      return ketQua;
    }
    return null;
  }

  /// Tìm kiếm đệ quy luồng màn hình chứa trong chuỗi từ màn hình hiện tại đi lên
  /// Dừng khi `kiemTra` trả về true hoặc không có luồng cha
  LuongManHinh? timKiemLuong(bool Function(LuongManHinh) kiemTra) {
    if (luongManHinh != null) {
      if (kiemTra(luongManHinh!)) {
        return luongManHinh;
      }
      return luongManHinh?.timKiemLuong(kiemTra);
    }
    return null;
  }

  /// Xây dựng giao diện người dùng
  Widget xayDungGiaoDienNguoiDung(BuildContext context, Map<String, dynamic>? thamSo) {
    if (widgetCuaManHinh != null) {
      return widgetCuaManHinh!;
    }
    throw Exception("${tuMieuTa()} cần khai báo `widgetCuaManHinh` hoặc override `xayDungGiaoDienNguoiDung`");
  }

}
