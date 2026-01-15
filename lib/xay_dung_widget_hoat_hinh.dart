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

/// Tạo lớp thực thi hiệu ứng hoạt hình
typedef XayDungWidgetHieuUngChuyenDong = Widget Function(BuildContext, Container, AnimationController);

// -- Hàm dựng sẵn

Widget _xayDungLopTruot(BuildContext context, Widget mucTieu, AnimationController dieuKhien, Offset toaDoBatDau) {
  final Animation<Offset> toaDo = Tween<Offset>(
    begin: toaDoBatDau,
    end: Offset.zero
  ).animate(dieuKhien);
  return SlideTransition(
    position: toaDo,
    child: mucTieu,
  );
}

/// Xây dựng Widget hoạt hình trượt xuống
Widget xayDungLopTruotXuong(BuildContext context, Widget mucTieu, AnimationController dieuKhien)
  => _xayDungLopTruot(context, mucTieu, dieuKhien, const Offset(0, -1.0));
/// Xây dựng Widget hoạt hình trượt lên
Widget xayDungLopTruotLen(BuildContext context, Widget mucTieu, AnimationController dieuKhien)
  => _xayDungLopTruot(context, mucTieu, dieuKhien, const Offset(0, 1.0));
/// Xây dựng Widget hoạt hình trượt trái sang phải
Widget xayDungLopTruotTraiSangPhai(BuildContext context, Widget mucTieu, AnimationController dieuKhien)
  => _xayDungLopTruot(context, mucTieu, dieuKhien, const Offset(-1.0, 0));
/// Xây dựng Widget hoạt hình trượt phải sang trái
Widget xayDungLopTruotPhaiSangTrai(BuildContext context, Widget mucTieu, AnimationController dieuKhien)
  => _xayDungLopTruot(context, mucTieu, dieuKhien, const Offset(1.0, 0));
/// Xây dựng Widget hoạt hình theo độ mờ (độ trong suốt)
Widget xayDungLopDoMo(BuildContext context, Widget mucTieu, AnimationController dieuKhien) {
  final Animation<double> doMo = Tween<double>(
    begin: 0,
    end: 1.0
  ).animate(dieuKhien);
  return FadeTransition(
    opacity: doMo,
    child: mucTieu
  );
}
/// Xây dựng Widget hoạt hình theo kích thước (zoom/scale)
Widget xayDungLopThuPhong(BuildContext context, Widget mucTieu, AnimationController dieuKhien) {
  final Animation<double> doThuPhong = Tween<double>(
    begin: 0,
    end: 1.0
  ).animate(CurvedAnimation(
    parent: dieuKhien,
    curve: Curves.easeInOutBack)
  );
  return ScaleTransition(
    scale: doThuPhong,
    child: mucTieu
  );
}
