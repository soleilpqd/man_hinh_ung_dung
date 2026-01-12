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

/// Widget cho luồng màn hình, kiểu đơn giản: chỉ hiển thị widget của màn hình chính hiện tại.
/// Không chuyển động hoạt hình, không tham số điều khiển.
class WidgetLuongManHinhDonGian extends WidgetCuaDieuKhienManHinh<LuongManHinh> {

  const WidgetLuongManHinhDonGian({super.key, required super.dieuKhienManHinh});

  @override
  State<StatefulWidget> createState()  => _TrangThaiWidgetLuongManHinhDonGian();

}

class _TrangThaiWidgetLuongManHinhDonGian extends TrangThaiWidgetCuaDieuKhien<WidgetLuongManHinhDonGian> {

  MucTrongLuongManHinh? _manHinhCanHienThi;

  @override
  void initState() {
    super.initState();
    _manHinhCanHienThi = widget.dieuKhienManHinh.manHinhHienTaiCuaLuong;
  }

  @override
  void capNhaptGiaoDienCuaManHinh({required DieuKhienManHinh dieuKhienManHinh, ThamSoDieuKhienWidgetManHinh? duLieuDinhKem}) {
    dynamic temp = duLieuDinhKem?[LuongManHinh.kKeyThamSoDieuKhienWidgetLuongMH];
    if (temp is ThamSoDieuKhienWidgetLuongManHinh) {
      final ThamSoDieuKhienWidgetLuongManHinh thamSo = temp;
      setState(() {
        _manHinhCanHienThi = thamSo.manHinhMoi;
      });
      thamSo.hoatTatThayDoi.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _manHinhCanHienThi?.taoContainer(context) ?? Container(color: Colors.white.withAlpha(0));
  }

}
