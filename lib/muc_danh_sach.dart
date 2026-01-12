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

typedef HamXayDungWidgetMucDanhSach = List<Widget> Function(BuildContext, MucDanhSach);

/// Bố cục các mục trong ListView theo các cấp để quản lý
/// Sau đó layout lần lượt thành 1 list các widget
class MucDanhSach {

  /// Dữ liệu đính kèm
  dynamic duLieuDinhKem;
  /// Widget trên (vd đường kẻ, khoảng cách ...)
  HamXayDungWidgetMucDanhSach? xayDungWidgetTren;
  /// Xây dựng widget cho chính mục hiện tại
  HamXayDungWidgetMucDanhSach xayDungWidgetChinh;
  /// Các mục con
  List<MucDanhSach> cacMucCon = [];
  /// Widget duoi (vd đường kẻ, khoảng cách ...)
  HamXayDungWidgetMucDanhSach? xayDungWidgetDuoi;

  MucDanhSach({required this.xayDungWidgetChinh});

  List<Widget> xayDungDanhSachWidgets(BuildContext context) {
    List<Widget> ketQua = [];
    List<Widget>? tam = xayDungWidgetTren?.call(context, this);
    if (tam != null && tam.isNotEmpty) {
      ketQua.addAll(tam);
    }
    tam = xayDungWidgetChinh(context, this);
    if (tam.isNotEmpty) {
      ketQua.addAll(tam);
    }
    for (final muc in cacMucCon) {
      tam = muc.xayDungDanhSachWidgets(context);
      if (tam.isNotEmpty) {
        ketQua.addAll(tam);
      }
    }
    tam = xayDungWidgetDuoi?.call(context, this);
    if (tam != null && tam.isNotEmpty) {
      ketQua.addAll(tam);
    }
    return ketQua;
  }

}
